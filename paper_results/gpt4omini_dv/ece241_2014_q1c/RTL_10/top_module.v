module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

    wire signed [8:0] sum;

    assign sum = {1'b0, a} + {1'b0, b}; // Perform addition with sign extension
    assign s = sum[7:0]; // Take the lower 8 bits for the result

    // Overflow detection logic
    assign overflow = (~a[7] & ~b[7] & s[7]) | (a[7] & b[7] & ~s[7]);

endmodule