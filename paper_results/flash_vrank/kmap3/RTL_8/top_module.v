module top_module (
    input a,
    input b,
    input c,
    input d,
    output reg out
);

    always @(*) begin
        if ((~a & b & ~c) || (a & ~b & ~c) || (a & ~b & d) || (a & c) || (~a & ~b & ~c & ~d) || (b & c & d) || (~a & c & d) || (b & c & ~d) || (a & b & ~d)) begin
            out = 1;
        end else begin
            out = 0;
        end
    end

endmodule