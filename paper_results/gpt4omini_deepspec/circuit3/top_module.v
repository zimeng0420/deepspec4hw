module top_module (
    input a, 
    input b, 
    input c, 
    input d,
    output q
);

    assign q = (b & d) | (b & c & ~d) | (b & c & 1) | (a & d) | (a & ~c & d) | (a & c & d) | (a & 1 & d) | (a & b & d) | (a & b & c);

endmodule