module top_module (
	input clk,
	input x,
	output z
);

	// Internal signals
	wire xor_out, and_out, or_out;
	wire q1_n, q2_n, q3_n;
	reg q1, q2, q3;

	// XOR gate
	xor #(1) xor1 (xor_out, x, q1);

	// AND gate
	and #(1) and1 (and_out, x, q2_n);

	// OR gate
	or #(1) or1 (or_out, x, q3_n);

	// D flip-flop 1
	always @(posedge clk) begin
		q1 <= xor_out;
	end

	// D flip-flop 2
	always @(posedge clk) begin
		q2 <= and_out;
	end

	// D flip-flop 3
	always @(posedge clk) begin
		q3 <= or_out;
	end

	// Invert flip-flop outputs
	assign q1_n = ~q1;
	assign q2_n = ~q2;
	assign q3_n = ~q3;

	// XNOR gate
	xnor #(1) xnor1 (z, q1, q2, q3);


endmodule