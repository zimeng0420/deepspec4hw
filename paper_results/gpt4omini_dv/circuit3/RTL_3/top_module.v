module top_module (
    input a, 
    input b, 
    input c, 
    input d,
    output q
);
    assign q = (b & d) | (b & c) | (b & (c & d)) | (a & d) | (a & c) | (a & (c & d)) | (a & b);
endmodule