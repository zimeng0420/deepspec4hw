module top_module (
	input clk,
	input x,
	output z
);

	// Internal signals
	wire xor_out;
	wire and_out;
	wire or_out;
	wire q1, q2, q3;
	wire not_q2, not_q3;

	// XOR gate and D flip-flop 1
	xor u1 (xor_out, x, q1);
	always @(posedge clk) begin
		q1 <= xor_out;
	end

	// NOT q2
	not u_not_q2 (not_q2, q2);

	// AND gate and D flip-flop 2
	and u2 (and_out, x, not_q2);
	always @(posedge clk) begin
		q2 <= and_out;
	end

	// NOT q3
	not u_not_q3 (not_q3, q3);

	// OR gate and D flip-flop 3
	or u3 (or_out, x, not_q3);
	always @(posedge clk) begin
		q3 <= or_out;
	end


	// XNOR gate
	xnor u4 (z, q1, q2, q3);

endmodule