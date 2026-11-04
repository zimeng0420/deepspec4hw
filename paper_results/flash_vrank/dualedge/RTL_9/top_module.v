module top_module(
    input clk,
    input d,
    output reg q
);

  reg clk_r;
  reg q_r;

  always @(posedge clk) begin
    clk_r <= clk;
    if (clk_r != clk) begin // Detect rising edge
      q_r <= d;
    end
  end

  always @(negedge clk) begin
    clk_r <= clk;
    if (clk_r != clk) begin // Detect falling edge
      q_r <= d;
    end
  end

  always @(q_r) begin
      q <= q_r;
  end

endmodule