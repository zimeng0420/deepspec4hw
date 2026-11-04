module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    typedef enum reg [2:0] {
        STATE_A,       // Initial state
        STATE_F,       // State where f is set to 1
        STATE_X1,      // First '1' detected for x sequence
        STATE_X10,     // '10' detected for x sequence
        STATE_X101,    // Full '101' sequence detected
        STATE_Y1_WAIT, // Waiting for y to become 1
        STATE_G1      // Maintain g = 1
    } state_t;

    state_t state, next_state;
    reg [1:0] y_counter; // Counter to track clock cycles for y

    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            y_counter <= 0;
        end else begin
            state <= next_state;
            if (state == STATE_X101) begin
                y_counter <= 0;
            end else if (state == STATE_Y1_WAIT) begin
                y_counter <= y_counter + 1;
            end
        end
    end

    always @(*) begin
        next_state = state; // Default state transition
        f = 0;
        g = 0;

        case (state)
            STATE_A: begin
                if (resetn) next_state = STATE_F;
            end
            STATE_F: begin
                f = 1;
                next_state = STATE_X1;
            end
            STATE_X1: begin
                if (x) next_state = STATE_X10;
            end
            STATE_X10: begin
                if (!x) next_state = STATE_X101;
            end
            STATE_X101: begin
                if (x) next_state = STATE_Y1_WAIT;
            end
            STATE_Y1_WAIT: begin
                if (y || y_counter == 2) next_state = STATE_G1;
            end
            STATE_G1: begin
                g = 1;
            end
        endcase
    end

    always @(posedge clk) begin
        if (state == STATE_G1 || (state == STATE_Y1_WAIT && y_counter == 2)) begin
            g <= 1;
        end else begin
            g <= 0;
        end
    end

endmodule