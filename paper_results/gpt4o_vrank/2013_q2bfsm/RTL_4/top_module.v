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
        STATE_F = 3'b101
    } state_t;

    state_t state, next_state;

    // State transition and output logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        // Default values
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            STATE_A: begin
                f = 0;
                g = 0;
                next_state = (resetn) ? STATE_B : STATE_A;
            end
            STATE_B: begin
                f = 1;
                g = 0;
                next_state = STATE_C;
            end
            STATE_C: begin
                f = 0;
                g = 0;
                if (x == 1) next_state = STATE_D;
            end
            STATE_D: begin
                f = 0;
                g = 0;
                if (x == 0) next_state = STATE_E;
                else if (x == 1) next_state = STATE_D;
            end
            STATE_E: begin
                f = 0;
                g = 0;
                if (x == 1) next_state = STATE_F;
                else if (x == 0) next_state = STATE_C;
            end
            STATE_F: begin
                f = 0;
                g = 1;
                if (y == 1) next_state = STATE_F;
                else begin
                    // Two-cycle countdown while g=1
                    g = 1;
                    if (y == 0) next_state = state;  // Stay in this state until y becomes 1 or countdown reached
                end
            end
            default: begin
                f = 0;
                g = 0;
                next_state = STATE_A;
            end
        endcase
    end

endmodule