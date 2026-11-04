module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

    wire [8:0] sum; // 9-bit to handle possible overflow
    assign sum = {1'b0, a} + {1'b0, b}; // Perform addition

    assign s = sum[7:0]; // Take the lower 8 bits as the result
    assign overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]); // Overflow detection logic

endmodule