module top_module (
    input a,
    input b,
    input c,
    input d,
    output reg out
);

    always @(*) begin
        if ((~a & b & ~c) || (a & ~b & ~c) || (a & b & ~c) || (~a & b & d) || (a & ~b & d) || (a & b & d) || (~a & ~b & c & ~d) || (a & ~b & c & ~d) || (a & b & c & ~d) || (a & ~b & c & d) || (a & b & c & d))
            out = 1'b1;
        else
            out = 1'b0;
    end

endmodule