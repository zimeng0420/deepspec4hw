module top_module(
    input clk,
    input d,
    output reg q
);

  reg clk_delayed;

  // Delay the clock to detect edges
  always @(posedge clk) begin
    clk_delayed <= clk;
  end

  // Implement dual-edge triggered flip-flop behavior
  always @(posedge clk or negedge clk) begin
    q <= d;
  end
endmodule