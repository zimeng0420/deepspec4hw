module top_module (
    input a,
    input b,
    input c,
    input d,
    output reg out
);

  always @(*) begin
    out = (b & ~d & ~a) | (b & ~d & a) | ( ~b & d & ~a) | (~b & d & a);
  end

endmodule