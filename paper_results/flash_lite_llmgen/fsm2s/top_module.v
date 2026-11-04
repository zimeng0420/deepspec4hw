module top_module (
	input clk,
	input j,
	input k,
	input reset,
	output out
);

    // Define states using parameters for readability and maintainability
    parameter OFF = 2'b00;
    parameter ON  = 2'b01;

    // Declare a register to store the current state
    reg [1:0] state; // Using 2 bits to represent 2 states (OFF and ON)

    // Declare a register to store the output
    reg out_reg;

    // State transition logic (always block triggered by the rising edge of the clock)
    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset to OFF state
            state <= OFF;
        end else begin
            // State transition based on current state and inputs
            case (state)
                OFF: begin
                    if (j) begin
                        state <= ON;
                    end else begin
                        state <= OFF;
                    end
                end
                ON: begin
                    if (k) begin
                        state <= OFF;
                    end else begin
                        state <= ON;
                    end
                end
                default: begin
                    // Should never happen, but good practice to have a default state
                    state <= OFF; // Default to OFF in case of an unexpected state
                end
            endcase
        end
    end

    // Output logic (always block triggered by the state change)
    always @(*) begin
        case (state)
            OFF: out_reg = 1'b0; // Output 0 when in OFF state
            ON:  out_reg = 1'b1; // Output 1 when in ON state
            default: out_reg = 1'b0; // Default output (OFF)
        endcase
    end

    // Assign the output register to the output port
    assign out = out_reg;

endmodule