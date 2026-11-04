module top_module (
    input a,
    input b,
    input c,
    input d,
    output reg out
);

  always @(*) begin
    out = (b & ~d & ~c) | (~b & ~d & c) | (b & d & ~c) | (~b & d & c);
  end

endmodule