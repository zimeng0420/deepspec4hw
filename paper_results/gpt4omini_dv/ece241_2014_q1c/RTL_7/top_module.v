module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire signed [8:0] sum; // 9-bit to accommodate overflow
    assign sum = {1'b0, a} + {1'b0, b}; // Zero-extend to 9 bits
    assign s = sum[7:0]; // Assign lower 8 bits to the output s
    assign overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]); // Overflow detection logic
endmodule