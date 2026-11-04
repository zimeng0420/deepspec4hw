module top_module (
    input a, 
    input b,
    input c,
    input d,
    output reg out
);

    always @(*) begin
        out = (~a & ~c & d) |   // Term 1
              (~b & c & ~d) |   // Term 2
              (~a & b & ~c) |   // Term 3
              (a & ~b & c);     // Term 4
    end

endmodule