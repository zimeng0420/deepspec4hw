module top_module (
	input clk,
	input reset,
	input x,
	output reg z
);

	reg [2:0] y_current, y_next;

	// State definitions
	localparam S0 = 3'b000;
	localparam S1 = 3'b001;
	localparam S2 = 3'b010;
	localparam S3 = 3'b011;
	localparam S4 = 3'b100;

	// State transition logic
	always @(*) begin
		case (y_current)
			S0: y_next = (x) ? S1 : S0;
			S1: y_next = (x) ? S4 : S1;
			S2: y_next = (x) ? S1 : S2;
			S3: y_next = (x) ? S2 : S1;
			S4: y_next = (x) ? S4 : S3;
			default: y_next = S0;
		endcase
	end

	// Output logic
	always @(*) begin
		case (y_current)
			S0: z = 1'b0;
			S1: z = 1'b0;
			S2: z = 1'b0;
			S3: z = 1'b1;
			S4: z = 1'b1;
			default: z = 1'b0;
		endcase
	end

	// State register
	always @(posedge clk) begin
		if (reset)
			y_current <= S0;
		else
			y_current <= y_next;
	end

endmodule