module top_module(
    input a,
    input b,
    input c,
    input d,
    output reg out
);

  // Simplified Boolean Expression derived from the Karnaugh map:
  // out = (a & c) | (a & d) | (b & c) | (b & d)

  always @(*) begin
    out = (a & c) | (a & d) | (b & c) | (b & d);
  end

endmodule