module top_module (
    input a,
    input b,
    input c,
    input d,
    output reg out
);

    always @(*) begin
        if ((~a & b & ~c & ~d) || (~a & ~b & c & ~d) || (~a & ~b & c & d) || (~a & b & c & d) || (a & ~b & c & ~d) || (a & b & c & ~d) || (a & ~b & c & d) || (a & b & c & d) || (~a & ~b & ~c & d) || (a & ~b & ~c & ~d) || (a & b & ~c & ~d) || (a & b & ~c & d)) begin
            out = 1;
        end else begin
            out = 0;
        end
    end

endmodule