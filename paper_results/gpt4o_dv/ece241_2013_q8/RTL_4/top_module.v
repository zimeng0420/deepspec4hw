module top_module (
	input clk,
	input aresetn,
	input x,
	output reg z
);

	// State encoding
	localparam S0 = 2'b00;
	localparam S1 = 2'b01;
	localparam S2 = 2'b10;

	reg [1:0] current_state, next_state;

	// State transition logic
	always @(*) begin
		case (current_state)
			S0: next_state = (x ? S1 : S0);
			S1: next_state = (x ? S1 : S2);
			S2: next_state = (x ? S1 : S0);
			default: next_state = S0;
		endcase
	end

	// Output logic
	always @(*) begin
		z = (current_state == S2 && x) ? 1'b1 : 1'b0;
	end

	// Sequential logic
	always @(posedge clk or negedge aresetn) begin
		if (!aresetn)
			current_state <= S0;
		else
			current_state <= next_state;
	end

endmodule