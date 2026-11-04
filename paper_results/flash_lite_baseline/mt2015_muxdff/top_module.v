module top_module(
	input clk,
	input L,
	input q_in,
	input r_in,
	output reg Q
);

  // Submodule: flipflop_mux
  module flipflop_mux (
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
        q_out <= q_in;
      end
    end

  endmodule

  // Instantiate three flipflop_mux modules
  wire w1, w2, w3;

  flipflop_mux ff1 (
    .clk(clk),
    .L(L),
    .r(r_in),
    .q_in(q_in),
    .q_out(w1)
  );

  flipflop_mux ff2 (
    .clk(clk),
    .L(L),
    .r(w1),
    .q_in(w1),
    .q_out(w2)
  );

  flipflop_mux ff3 (
    .clk(clk),
    .L(L),
    .r(w2),
    .q_in(w2),
    .q_out(Q)
  );

endmodule