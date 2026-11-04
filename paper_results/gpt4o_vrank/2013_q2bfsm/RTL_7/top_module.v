module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // Define state encoding
    typedef enum reg [2:0] {
        STATE_A = 3'b000,
        STATE_B = 3'b001,
        STATE_C = 3'b010,
        STATE_D = 3'b011,
        STATE_E = 3'b100,
        STATE_F = 3'b101,
        STATE_G = 3'b110
    } state_t;

    state_t state, next_state;
    reg [1:0] y_check;

    always @(posedge clk) begin
        if (~resetn)
            state <= STATE_A;
        else
            state <= next_state;
    end

    always @(*) begin
        // Default output values
        f = 0;
        g = 0;
        next_state = state;

        case (state)
            STATE_A: begin
                // Assert reset state
                if (~resetn) begin
                    next_state = STATE_A;
                end else begin
                    next_state = STATE_B;
                end
            end
            STATE_B: begin
                // Set f to 1 for one clock cycle after reset is released
                f = 1;
                next_state = STATE_C;
            end
            STATE_C: begin
                // Monitor for x = 1
                if (x == 1)
                    next_state = STATE_D;
            end
            STATE_D: begin
                // Monitor for x = 0
                if (x == 0)
                    next_state = STATE_E;
                else if (x == 1)
                    next_state = STATE_D; // Stay in D if x remains 1
            end
            STATE_E: begin
                // Monitor for x = 1
                if (x == 1)
                    next_state = STATE_F;
                else
                    next_state = STATE_C; // Return to wait for 101 pattern
            end
            STATE_F: begin
                // Set g to 1, and start monitoring y
                g = 1;
                next_state = STATE_G;
                y_check = 2'b00; // Reset y-check counter
            end
            STATE_G: begin
                // Monitor y for two clock cycles
                g = 1; // Maintain g = 1 during this state
                y_check = y_check + 1;
                if (y == 1) begin
                    // Maintain g = 1 permanently
                    next_state = STATE_G;
                end else if (y_check == 2'b10) begin
                    // y did not become 1 in two cycles
                    g = 0;
                    next_state = STATE_A; // Reset FSM
                end
            end
        endcase
    end

endmodule