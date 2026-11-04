module top_module (
	input clk,
	input x,
	output z
);

  reg d1, d2, d3;
  wire q1, q2, q3;

  assign z = ~(q1 ^ q2 ^ q3);

  always @(posedge clk) begin
    d1 <= x ^ d1;
    d2 <= x & ~d2;
    d3 <= x | ~d3;
  end

  assign q1 = d1;
  assign q2 = d2;
  assign q3 = d3;

endmodule