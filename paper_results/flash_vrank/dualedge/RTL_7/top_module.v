module top_module(
    input clk,
    input d,
    output reg q
);

  reg clk_r;
  reg d_r;

  always @(posedge clk) begin
    clk_r <= ~clk_r; // Toggle clk_r on every rising edge of clk.
    if (clk_r == 1'b0) begin
      d_r <= d; // Latch d on the 'positive' edge of clk_r, which corresponds to posedge clk
    end
    else begin
      d_r <= d; //Latch d on the 'negative' edge of clk_r, which corresponds to negedge clk
    end
    q <= d_r;
  end

endmodule