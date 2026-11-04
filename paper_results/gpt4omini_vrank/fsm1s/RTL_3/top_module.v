module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    typedef enum logic [1:0] {
        B = 1'b0,
        A = 1'b1
    } state_t;

    state_t current_state, next_state;

    // State transition
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= B; // Reset to state B
        end else begin
            current_state <= next_state; // Update current state
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            B: begin
                out = 1; // Output for state B
                if (in) 
                    next_state = B; // Stay in B if in is 1
                else 
                    next_state = A; // Go to A if in is 0
            end
            A: begin
                out = 0; // Output for state A
                if (in) 
                    next_state = A; // Stay in A if in is 1
                else 
                    next_state = B; // Go to B if in is 0
            end
            default: begin
                next_state = B; // Default state
                out = 1; // Default output
            end
        endcase
    end

endmodule