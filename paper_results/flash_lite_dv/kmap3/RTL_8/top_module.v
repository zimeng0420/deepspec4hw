module top_module(
    input a,
    input b,
    input c,
    input d,
    output reg out
);

  // Simplified Boolean expression derived from the Karnaugh map:
  // out = (b & c) | (a & c) | (a & b & d)

  always @(*) begin
    out = (b & c) | (a & c) | (a & b & d);
  end

endmodule