module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] sum; // 9 bits to hold carry for overflow detection
    assign sum = {1'b0, a} + {1'b0, b}; // Extend a and b to 9 bits and add

    assign s = sum[7:0]; // Assign the lower 8 bits to s
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]); // Overflow occurs when signs of a and b are same and differ from the result sign
endmodule