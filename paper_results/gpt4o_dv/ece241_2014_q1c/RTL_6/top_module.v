module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

    // Compute the sum of a and b
    assign s = a + b;
    
    // Detect overflow
    // Overflow occurs when the sign bit of both a and b are the same,
    // but the sign bit of the result s is different.
    assign overflow = (a[7] == b[7]) && (a[7] != s[7]);

endmodule