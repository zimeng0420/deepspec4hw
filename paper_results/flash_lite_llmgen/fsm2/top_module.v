module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output out
);

    // Define states using parameters for readability and maintainability
    parameter OFF = 0;
    parameter ON  = 1;

    // Declare a register to store the current state
    reg state;

    // Declare a register to store the output
    reg out;

    // State transition logic and output assignment
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset to OFF state
            state <= OFF;
            out <= 0; // Ensure output is 0 in OFF state
        end else begin
            // Synchronous state transition logic
            case (state)
                OFF: begin
                    // OFF state transitions
                    if (j) begin
                        state <= ON;
                    end else begin
                        state <= OFF;
                    end
                    out <= 0; // Output is 0 in OFF state
                end
                ON: begin
                    // ON state transitions
                    if (k) begin
                        state <= OFF;
                    end else begin
                        state <= ON;
                    end
                    out <= 1; // Output is 1 in ON state
                end
                default: begin
                    // Handle unexpected states (optional, for robustness)
                    state <= OFF; // Default to OFF
                    out <= 0;
                end
            endcase
        end
    end

endmodule