module top_module(
	input clk,
	input d,
	output reg q);

  reg clk_r;
  reg d_r;

  always @(posedge clk) begin
    clk_r <= ~clk;
    d_r <= d;
  end

  always @(posedge clk_r) begin
    q <= d_r;
  end

endmodule