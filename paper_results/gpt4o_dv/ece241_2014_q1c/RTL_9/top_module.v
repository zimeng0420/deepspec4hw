module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    
    // Compute the sum of a and b
    assign s = a + b;
    
    // Detect overflow: overflow occurs if the signs of a and b are the same,
    // but the sign of the result is different.
    assign overflow = (a[7] == b[7]) && (a[7] != s[7]);

endmodule