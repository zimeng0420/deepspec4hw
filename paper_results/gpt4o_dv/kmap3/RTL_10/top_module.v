module top_module (
    input a,
    input b,
    input c,
    input d,
    output reg out
);

always @(*) begin
    out = (~c & d) | (c & d) | (~a & ~b & c);
end

endmodule