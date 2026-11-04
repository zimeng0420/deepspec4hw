module top_module(
	input clk,
	input L,
	input q_in,
	input r_in,
	output reg Q);

	// Submodule: Flip-Flop with 2:1 Mux
	module ff_mux (
		input clk,
		input L,
		input r,
		input q_in,
		output reg q_out
	);

		always @(posedge clk) begin
			if (L) begin
				q_out <= r;
			end else begin
				q_out <= (q_in); // Simplified for the given behavior.  No need for XOR in the basic case
			end
		end

	endmodule

	wire [2:0] r_internal;
	wire [2:0] q_internal;

	assign r_internal[0] = r_in;
	assign r_internal[1] = r_in;
	assign r_internal[2] = r_in;


	// Instantiate three ff_mux submodules
	ff_mux ff_mux_0 (
		.clk(clk),
		.L(L),
		.r(r_internal[0]),
		.q_in(q_internal[2]),
		.q_out(Q)
	);


endmodule