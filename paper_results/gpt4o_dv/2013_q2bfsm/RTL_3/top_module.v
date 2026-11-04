module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum reg [2:0] {
        STATE_A = 3'b000,
        STATE_B = 3'b001,
        STATE_C = 3'b010,
        STATE_D = 3'b011,
        STATE_E = 3'b100
    } state_t;

    // State registers
    reg [2:0] current_state, next_state;
    reg [1:0] y_counter;

    always @(posedge clk) begin
        if (~resetn) begin
            current_state <= STATE_A;
            y_counter <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        // Default assignments
        next_state = current_state;
        f = 0;
        case (current_state)
            STATE_A: begin
                if (resetn) begin
                    next_state = STATE_B;
                    f = 1;
                end
            end
            STATE_B: begin
                if (x) begin
                    next_state = STATE_C;
                end
            end
            STATE_C: begin
                if (~x) begin
                    next_state = STATE_D;
                end
            end
            STATE_D: begin
                if (x) begin
                    next_state = STATE_E;
                    g = 1;
                end
            end
            STATE_E: begin
                if (~g) begin
                    next_state = STATE_A; // If FSM starts over
                end else if (y_counter == 2'b10 && !y) begin
                    g = 0; // Set g to 0 after two cycles if y is not 1
                end
            end
        endcase
    end

    always @(posedge clk) begin
        if (current_state == STATE_E) begin
            if (g && y_counter < 2'b10) begin
                if (y) begin
                    y_counter <= 2'b10; // g remains 1 permanently if y is 1
                end else begin
                    y_counter <= y_counter + 1; // Increment counter
                end
            end
        end else begin
            y_counter <= 0; // Reset y_counter if not in STATE_E
        end
    end

endmodule