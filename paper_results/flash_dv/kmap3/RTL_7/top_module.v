module top_module (
    input a,
    input b,
    input c,
    input d,
    output reg out
);

    always @(*) begin
        out <= (a & d) | (b & c) | (b & d);
    end

endmodule