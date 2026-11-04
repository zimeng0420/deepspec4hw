module top_module (
	input [3:0] a, 
	input [3:0] b, 
	input [3:0] c, 
	input [3:0] d,
	input [3:0] e,
	output reg [3:0] q
);

	always @(*) begin
		case (c)
			0: q = b;
			1: q = e;
			2: q = a;
			3: q = d;
			4: q = 4'hf;
			5: q = 4'hf;
			6: q = 4'hf;
			7: q = 4'hf;
			8: q = 4'hf;
			9: q = 4'hf;
			10: q = 4'hf; // a
			11: q = 4'hf; // b
			12: q = 4'hf; // c
			13: q = 4'hf; // d
			14: q = 4'hf; // e
			15: q = 4'hf; // f
			default: q = 4'hf;
		endcase
	end

endmodule