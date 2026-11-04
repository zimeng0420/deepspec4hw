module top_module(
    input a,
    input b,
    input c,
    input d,
    output reg out
);

  always @(*) begin
    // Derived Boolean expression from Karnaugh map
    // out = a & c | a & d | b & c | b & d | a & b;
    out = (a & c) | (a & d) | (b & c) | (b & d) | (a & b);
  end

endmodule