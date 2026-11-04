module top_module (
    input a,
    input b,
    input c,
    input d,
    output reg out
);

    always @(*) begin
        out = a | (~c & ~d) | (~a & ~b & c);
    end

endmodule