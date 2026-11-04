module top_module (
	input clk,
	input x,
	input [2:0] y,
	output reg Y0,
	output reg z
);

	reg [2:0] Y_next;

	always @(*) begin
		case (y)
			3'b000: Y_next = x ? 3'b001 : 3'b000;
			3'b001: Y_next = x ? 3'b100 : 3'b001;
			3'b010: Y_next = x ? 3'b001 : 3'b010;
			3'b011: Y_next = x ? 3'b010 : 3'b001;
			3'b100: Y_next = x ? 3'b100 : 3'b011;
			default: Y_next = 3'b000; // Default state
		endcase
	end

	always @(*) begin
		case (y)
			3'b000: z = 1'b0;
			3'b001: z = 1'b0;
			3'b010: z = 1'b0;
			3'b011: z = 1'b1;
			3'b100: z = 1'b1;
			default: z = 1'b0; // Default output
		endcase
	end

	always @(posedge clk) begin
		y[0] <= Y_next[0];
		y[1] <= Y_next[1];
		y[2] <= Y_next[2];
		Y0 <= Y_next[0];
	end

endmodule