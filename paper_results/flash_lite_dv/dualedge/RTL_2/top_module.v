module top_module(
    input clk,
    input d,
    output reg q
);

  reg clk_delayed;

  always @(posedge clk) begin
    clk_delayed <= clk;
  end

  always @(posedge clk or negedge clk) begin
    q <= d;
  end

endmodule