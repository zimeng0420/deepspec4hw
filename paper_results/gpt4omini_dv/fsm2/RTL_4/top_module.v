module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output reg out
);

reg state; // Current state

// State definitions
localparam OFF = 1'b0;
localparam ON  = 1'b1;

// Asynchronous reset and state transition
always @(posedge clk or posedge areset) begin
	if (areset) begin
		state <= OFF; // Reset state to OFF
	end else begin
		case (state)
			OFF: begin
				if (j) state <= ON; // Transition to ON if j = 1
			end
			ON: begin
				if (k) state <= OFF; // Transition to OFF if k = 1
			end
		endcase
	end
end

// Output logic
always @(state) begin
	out = state; // Output follows the current state
end

endmodule