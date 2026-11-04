module top_module (
    input a, 
    input b, 
    input c, 
    input d,
    output q
);

assign q = (b == 1 && d == 0) || (a == 1 && c == 1) || (a == 1 && b == 1) || (c == 1 && d == 1);

endmodule