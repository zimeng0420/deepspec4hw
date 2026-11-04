module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

wire [8:0] sum; // 9 bits to handle overflow
assign sum = {1'b0, a} + {1'b0, b}; // add with an extra bit for overflow detection
assign s = sum[7:0]; // take lower 8 bits for the result

// Overflow occurs if the sign of a and b are the same and the sign of the result is different
assign overflow = ((a[7] == b[7]) && (s[7] != a[7]));

endmodule