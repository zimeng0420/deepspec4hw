module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire signed [8:0] sum;
    assign sum = {1'b0, a} + {1'b0, b}; // Sign extend to 9 bits for overflow detection
    assign s = sum[7:0];
    assign overflow = (a[7] == b[7]) && (a[7] != s[7]); // Overflow occurs if signs of a and b are the same but differ in s

endmodule