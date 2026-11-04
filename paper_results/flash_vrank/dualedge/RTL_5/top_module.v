module top_module(
	input clk,
	input d,
	output reg q);

  reg clk_pos;
  reg clk_neg;

  always @(posedge clk)
    clk_pos <= 1;

  always @(negedge clk)
    clk_neg <= 1;

  always @(clk_pos or clk_neg) begin
    if (clk_pos) begin
      q <= d;
      clk_pos <= 0; // Reset the flag
    end else if (clk_neg) begin
      q <= d;
      clk_neg <= 0; // Reset the flag
    end
  end

endmodule