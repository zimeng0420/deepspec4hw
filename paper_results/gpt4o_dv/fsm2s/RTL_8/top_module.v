module top_module (
	input clk,
	input j,
	input k,
	input reset,
	output reg out
);

	// State encoding
	localparam OFF = 1'b0;
	localparam ON  = 1'b1;

	reg current_state, next_state;

	// Synchronous state transition
	always @(posedge clk) begin
		if (reset) begin
			current_state <= OFF;  // Reset to OFF state
		end else begin
			current_state <= next_state;  // Transition to next state
		end
	end

	// Combinational logic for next state
	always @(*) begin
		case (current_state)
			OFF: next_state = (j == 1'b1) ? ON : OFF;
			ON:  next_state = (k == 1'b1) ? OFF : ON;
			default: next_state = OFF;  // Default state
		endcase
	end

	// Output logic based on the current state (Moore output)
	always @(*) begin
		out = current_state;  // OFF -> out=0, ON -> out=1
	end

endmodule