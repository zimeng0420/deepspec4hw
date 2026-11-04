module top_module(
    input a,
    input b,
    input c,
    input d,
    output reg out
);

  always @(*) begin
    // Simplified Boolean expression derived from the Karnaugh map:
    // out = a & c | a & b | b & c | a & d
    out = (a & c) | (a & b) | (b & c) | (a & d);
  end
endmodule