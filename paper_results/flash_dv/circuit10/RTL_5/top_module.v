module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state
);

  reg q;
  assign state = q;

  always @(posedge clk) begin
    if (~a & b)
      q <= 1;
    else if (a & ~b)
      q <= 1;
    else if (a & b)
      q <= ~q;
    else
      q <= 0;
  end

  assign q = (a & b) ? q : ((~a & b) | (a & ~b)) ? 1'b1 : 1'b0;
  assign state = q;
endmodule