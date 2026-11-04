module top_module (
	input a,
	input b,
	input sel,
	output out
);

	always @(*) begin
		case (sel)
			0: out = a;
			1: out = b;
			default: out = 1'bx;
		endcase
	end

endmodule