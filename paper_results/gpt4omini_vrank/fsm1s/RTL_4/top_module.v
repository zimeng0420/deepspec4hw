module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);
    typedef enum reg [1:0] {B, A} state_t; // Define states
    state_t current_state, next_state; // Current and next state variables

    // State Transition
    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= B; // Reset to state B
        end else begin
            current_state <= next_state; // Transition to the next state
        end
    end

    // Next State Logic
    always @(*) begin
        case (current_state)
            B: begin
                if (in) begin
                    next_state = B; // Stay in B on in=1
                end else begin
                    next_state = A; // Go to A on in=0
                end
            end
            A: begin
                if (in) begin
                    next_state = A; // Stay in A on in=1
                end else begin
                    next_state = B; // Go to B on in=0
                end
            end
            default: next_state = B; // Default case
        endcase
    end

    // Output Logic
    always @(*) begin
        case (current_state)
            B: out = 1; // Output is 1 in state B
            A: out = 0; // Output is 0 in state A
            default: out = 1; // Default output
        endcase
    end
endmodule