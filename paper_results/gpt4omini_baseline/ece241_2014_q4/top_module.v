module top_module (
	input clk,
	input x,
	output z
);

	reg dff_xor;
	reg dff_and;
	reg dff_or;

	wire xor_out;
	wire and_out;
	wire or_out;

	// D Flip-Flops
	always @(posedge clk) begin
		dff_xor <= xor_out;
		dff_and <= and_out;
		dff_or <= or_out;
	end

	// XOR Gate
	assign xor_out = x ^ dff_xor;

	// AND Gate
	assign and_out = x & ~dff_and;

	// OR Gate
	assign or_out = x | ~dff_or;

	// XNOR output
	assign z = ~(dff_xor ^ dff_and ^ dff_or);

endmodule