module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

    // Compute the sum
    assign s = a + b;
    
    // Determine the overflow
    assign overflow = (a[7] == b[7]) && (a[7] != s[7]);

endmodule