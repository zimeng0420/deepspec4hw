module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State declaration
    typedef enum logic [1:0] {
        S0, // Initial state, waiting for first '1'
        S1  // Inverting state
    } state_t;

    state_t state, next_state;

    // State transition and output logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;       // Reset state
            z <= 1'b1;         // Output reset to known state
        end else begin
            state <= next_state; // Update state on clock
        end
    end

    // Next state and output logic
    always_comb begin
        // Default values
        next_state = state;
        z = 1'b0; // Default output

        case (state)
            S0: begin
                z = 1'b1; // Output for initial state
                if (x) begin
                    next_state = S1; // Transition to inversion state when first '1' received
                end
            end
            S1: begin
                z = ~x; // Inverted output in S1
                // Remain in S1 for every subsequent input
            end
        endcase
    end

endmodule