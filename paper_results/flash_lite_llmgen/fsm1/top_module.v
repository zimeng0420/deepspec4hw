module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    // Define the states using parameters for readability and maintainability
    parameter STATE_A = 0;
    parameter STATE_B = 1;

    // Declare a register to store the current state
    reg [0:0] current_state; // Using a single bit for the state (0 for A, 1 for B)

    // State transition logic and output assignment
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset: go to state B
            current_state <= STATE_B;
            out <= 1; // Output for state B
        end else begin
            // Synchronous state transitions
            case (current_state)
                STATE_A: begin
                    out <= 0; // Output for state A
                    if (in) begin
                        current_state <= STATE_A; // Stay in A if in = 1
                    end else begin
                        current_state <= STATE_B; // Go to B if in = 0
                    end
                end
                STATE_B: begin
                    out <= 1; // Output for state B
                    if (in) begin
                        current_state <= STATE_B; // Stay in B if in = 1
                    end else begin
                        current_state <= STATE_A; // Go to A if in = 0
                    end
                end
                default: begin // Handle any unexpected state (shouldn't happen, but good practice)
                    current_state <= STATE_B; // Default to B
                    out <= 1;
                end
            endcase
        end
    end

endmodule