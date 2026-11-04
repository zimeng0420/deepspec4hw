module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

    wire [8:0] sum;  // Need an extra bit to detect overflow

    assign sum = a + b;
    assign s = sum[7:0];
    assign overflow = sum[8] ^ s[7];

endmodule