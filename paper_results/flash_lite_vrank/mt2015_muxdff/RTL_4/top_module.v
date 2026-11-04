module top_module(
	input clk,
	input L,
	input q_in,
	input r_in,
	output reg Q
);

	// Submodule: Flip-Flop with 2:1 Mux
	module ff_mux (
		input clk,
		input L,
		input d_in,
		input r_in,
		output reg q_out
	);

		always @(posedge clk) begin
			if (L) begin
				q_out <= r_in;
			end else begin
				q_out <= {q_out}; // Simplified: Use existing value
			end
		end

	endmodule

	// Instantiate three ff_mux submodules, and connect with the same clk and L signals
	wire w1, w2, w3;

	ff_mux ff_mux_inst0 (
		.clk(clk),
		.L(L),
		.d_in(q_in),
		.r_in(r_in),
		.q_out(w1)
	);

    assign Q = w1;
endmodule