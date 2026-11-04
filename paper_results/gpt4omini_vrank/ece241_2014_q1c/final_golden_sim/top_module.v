module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] sum;

    assign sum = {1'b0, a} + {1'b0, b}; // 9-bit sum to detect overflow
    assign s = sum[7:0]; // Lower 8 bits are the sum
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]); // Check for overflow condition

endmodule