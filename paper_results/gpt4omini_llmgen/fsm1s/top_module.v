module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

// State Declaration
typedef enum logic [1:0] {
    B, // State B
    A  // State A
} state_t;

// State Variable
state_t current_state, next_state;

// State Update Block (Synchronous)
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= B; // Reset to state B
    end else begin
        current_state <= next_state; // Transition to next state
    end
end

// Next State Logic
always_ff @(current_state, in) begin
    case (current_state)
        B: begin
            out = 1; // Output for state B
            if (in == 0) begin
                next_state = A; // Transition to A on in=0
            end else begin
                next_state = B; // Stay in B on in=1
            end
        end
        A: begin
            out = 0; // Output for state A
            if (in == 0) begin
                next_state = B; // Transition to B on in=0
            end else begin
                next_state = A; // Stay in A on in=1
            end
        end
    endcase
end

endmodule