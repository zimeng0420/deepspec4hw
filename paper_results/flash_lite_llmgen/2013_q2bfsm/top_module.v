module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State Definitions
    parameter STATE_A = 3'b000; // Reset State
    parameter STATE_B = 3'b001; // Set f = 1
    parameter STATE_C = 3'b010; // Check x[0]
    parameter STATE_D = 3'b011; // Check x[1]
    parameter STATE_E = 3'b100; // Check x[2]
    parameter STATE_F = 3'b101; // Set g = 1, Monitor y
    parameter STATE_G = 3'b110; // Monitor y (Cycle 1 after g=1)
    parameter STATE_H = 3'b111; // Monitor y (Cycle 2 after g=1)

    // Internal Signals
    reg [2:0] current_state, next_state;
    reg [1:0] x_history; // Store the last two values of x

    // State Transition Logic
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            current_state <= STATE_A;
        else
            current_state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            STATE_A: begin
                next_state = STATE_B;
                f = 0;
                g = 0;
            end
            STATE_B: begin
                next_state = STATE_C;
                f = 1;
                g = 0;
            end
            STATE_C: begin
                x_history = {x_history[0], x}; // Shift history
                if (x == 1)
                    next_state = STATE_D;
                else
                    next_state = STATE_C;
                f = 0;
                g = 0;
            end
            STATE_D: begin
                x_history = {x_history[0], x}; // Shift history
                if (x == 0)
                    next_state = STATE_E;
                else
                    next_state = STATE_C;
                f = 0;
                g = 0;
            end
            STATE_E: begin
                x_history = {x_history[0], x}; // Shift history
                if (x == 1)
                    next_state = STATE_F;
                else
                    next_state = STATE_C;
                f = 0;
                g = 0;
            end
            STATE_F: begin
                if (y == 1)
                    next_state = STATE_F; // Stay in F, g = 1
                else
                    next_state = STATE_G;
                f = 0;
                g = 1;
            end
            STATE_G: begin
                if (y == 1)
                    next_state = STATE_F; // Stay in F, g = 1
                else
                    next_state = STATE_H;
                f = 0;
                g = 1;
            end
            STATE_H: begin
                next_state = STATE_H; // Stay in H, g = 0
                f = 0;
                g = 0;
            end
            default: begin
                next_state = STATE_A;
                f = 0;
                g = 0;
            end
        endcase
    end

endmodule