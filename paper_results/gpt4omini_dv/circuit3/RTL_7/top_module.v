module top_module (
    input a, 
    input b, 
    input c, 
    input d,
    output q
);
    assign q = (b & d) | (b & c & ~d) | (b & c) | (a & ~b & d) | (a & ~b & ~c) | (a & b & d) | (a & b & ~c) | (a & b) | (a & c & ~d);
endmodule