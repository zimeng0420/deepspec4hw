module top_module(
    input a,
    input b,
    input c,
    input d,
    output reg out
);

  // Simplified Boolean expression derived from the Karnaugh map
  // out = (b & c) | (a & d) | (a & b & ~c)
  always @(*) begin
    out = (b & c) | (a & d) | (a & b & ~c);
  end

endmodule