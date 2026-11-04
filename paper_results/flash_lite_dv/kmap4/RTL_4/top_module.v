module top_module (
    input a,
    input b,
    input c,
    input d,
    output reg out
);

    always @(*) begin
        out = (b & ~d) | (~b & d) | (~b & ~d);
    end

endmodule