module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state
);

  reg q;

  always @(posedge clk) begin
    q <= (~a & ~b) | (q & a & b);
  end

  assign state = q;
  assign q = (~state & ~a & b) | (~state & a & ~b) | (state & ~a & ~b) | (state & a & b);

endmodule