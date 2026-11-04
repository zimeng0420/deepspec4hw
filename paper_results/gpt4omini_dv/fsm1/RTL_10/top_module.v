module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    // State encoding
    typedef enum logic [1:0] {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t current_state, next_state;

    // Asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= B; // Reset to state B
        end else begin
            current_state <= next_state; // Update to next state
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            A: begin
                if (in == 0)
                    next_state = B;
                else
                    next_state = A;
                out = 0; // Output from state A
            end
            B: begin
                if (in == 0)
                    next_state = A;
                else
                    next_state = B;
                out = 1; // Output from state B
            end
            default: begin
                next_state = A; // Default case
                out = 0; // Default output
            end
        endcase
    end

endmodule