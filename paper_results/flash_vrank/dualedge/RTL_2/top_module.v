module top_module(
    input clk,
    input d,
    output reg q
);

  reg clk_r;
  reg q_r;

  always @(clk) begin
    clk_r <= clk;
    if (clk != clk_r) begin
      q_r <= d;
    end
  end

  always @* begin
    q = q_r;
  end
endmodule