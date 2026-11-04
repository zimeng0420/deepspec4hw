module top_module(
	input clk,
	input L,
	input q_in,
	input r_in,
	output reg Q
);

  // Flip-flop
  reg ff_out;
  always @(posedge clk) begin
    ff_out <= L ? r_in : q_in;
  end

  // 2-1 Multiplexer
  always @(*) begin
    Q = ff_out;
  end

endmodule