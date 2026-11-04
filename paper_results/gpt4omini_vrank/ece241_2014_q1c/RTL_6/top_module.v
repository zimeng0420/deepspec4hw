module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] sum; // 9 bits to capture overflow
    assign sum = {1'b0, a} + {1'b0, b}; // Sign extension

    assign s = sum[7:0]; // 8-bit result
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]); // Overflow condition
endmodule