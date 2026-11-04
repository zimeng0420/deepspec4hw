module top_module (
	input clk,
	input in,
	output logic out
);

	// Internal wire to connect the XOR output to the D input of the flip-flop
	logic xor_out;

	// XOR gate instantiation
	xor #(1) xor_gate (
		.in1(in),
		.in2(out),
		.out(xor_out)
	);

	// D flip-flop instantiation
	always_ff @(posedge clk) begin
		out <= xor_out;
	end

endmodule