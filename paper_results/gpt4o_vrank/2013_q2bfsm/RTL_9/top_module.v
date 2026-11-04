module top_module (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum {A, B, C, D, E, F, G, H} state_t;
    state_t state, next_state;

    // Reset and state transition logic
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        // Default assignments
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            A: begin
                f = 0;
                g = 0;
                if (!resetn) next_state = A;
                else next_state = B;
            end
            B: begin
                f = 1;
                g = 0;
                next_state = C;
            end
            C: begin
                f = 0;
                if (x == 1) next_state = D;
                else next_state = C;
            end
            D: begin
                if (x == 0) next_state = E;
                else next_state = D;
            end
            E: begin
                if (x == 1) next_state = F;
                else next_state = C;
            end
            F: begin
                g = 1;
                if (y == 1) next_state = H;
                else next_state = G;
            end
            G: begin
                g = 1;
                if (y == 1) next_state = H;
                else next_state = A;  // Return to initial state if y != 1
            end
            H: begin
                g = 1;
                next_state = H;  // Stay in H indefinitely
            end
            default: next_state = A;
        endcase
    end

endmodule