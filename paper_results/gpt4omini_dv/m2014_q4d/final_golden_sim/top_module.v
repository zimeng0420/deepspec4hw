module top_module (
	input clk,
	input in,
	output logic out
);
	// Intermediate wire for the XOR output
	logic xor_out;

	// XOR gate computation
	assign xor_out = in ^ out;

	// D flip-flop behavior
	always_ff @(posedge clk) begin
		out <= xor_out;
	end
endmodule