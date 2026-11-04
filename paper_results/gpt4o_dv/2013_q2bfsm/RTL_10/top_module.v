module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum logic [2:0] {
        STATE_A = 3'b000,
        STATE_B = 3'b001,
        STATE_C = 3'b010,
        STATE_D = 3'b011,
        STATE_E = 3'b100,
        STATE_F = 3'b101
    } state_t;

    state_t state, next_state;
    reg [1:0] y_counter;
    reg detect_101;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            f <= 0;
            g <= 0;
            y_counter <= 2'b00;
            detect_101 <= 0;
        end else begin
            state <= next_state;

            // Output logic
            f <= (state == STATE_A);
            g <= (state == STATE_E) || ((state == STATE_F) && g); // Keep g high if in STATE_F

            if (state == STATE_D && y == 0)
                y_counter <= y_counter + 1;

            if (state == STATE_E && y == 1)
                y_counter <= 2'b00;
        end
    end

    always @(*) begin
        // Default values
        next_state = state;

        case (state)
            STATE_A:
                if (resetn)
                    next_state = STATE_B;

            STATE_B:
                next_state = STATE_C;

            STATE_C:
                if (x == 1)
                    next_state = STATE_D;

            STATE_D:
                if (y == 1) 
                    next_state = STATE_E;
                else if (y_counter == 2'b01) 
                    next_state = STATE_F;

            STATE_E:
                if (x == 1 && detect_101)
                    next_state = STATE_F;

            STATE_F: 
                if (y == 0 & y_counter == 2'b01)
                    next_state = STATE_F;
                else
                    next_state = STATE_A;

            default: 
                next_state = STATE_A;
        endcase

        // Detect 101 pattern
        if (state == STATE_C && x == 1 && next_state == STATE_D)
            detect_101 = 1;
        else if (state == STATE_F)
            detect_101 = 0;
    end

endmodule