module top_module (
    input a,
    input b,
    input c,
    input d,
    output reg out
);

always @(*) begin
    out = c | (~c & ~d & a);
end

endmodule