module top_module (
    input a,
    input b,
    input c,
    input d,
    output reg out
);
    always @(*) begin
        out = (~a & ~c & d) | (~b & c & ~d) | (~a & b & ~c) | (a & ~b & c);
    end
endmodule