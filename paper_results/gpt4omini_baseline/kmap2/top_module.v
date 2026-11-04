module top_module (
    input a, 
    input b,
    input c,
    input d,
    output out
);

assign out = (c ~^ d) & (b | ~a) | (c & d & b) | (a & ~b & d) | (a & c & ~b);

endmodule