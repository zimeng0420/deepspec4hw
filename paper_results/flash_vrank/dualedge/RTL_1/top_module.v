module top_module(
    input clk,
    input d,
    output reg q
);

  reg clk_r; // Delayed clock signal
  reg q_r;   // Intermediate output

  always @(posedge clk) begin
    clk_r <= clk;
  end

  always @(posedge clk or posedge clk_r) begin
    if (clk != clk_r) begin // Detect a clock edge
      q_r <= d;
    end
  end

  always @(posedge clk) begin
    q <= q_r;
  end

endmodule