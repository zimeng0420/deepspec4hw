module top_module (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    wire [7:0] sum;

    // 8-bit adder
    assign sum = a + b;

    // Overflow detection
    assign overflow = (a[7] == b[7]) && (a[7] != sum[7]);

    // Assign sum to s
    assign s = sum;

endmodule