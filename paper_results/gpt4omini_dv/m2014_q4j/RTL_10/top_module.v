module top_module (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire c1, c2, c3; // carry wires

    // Full Adder 0
    wire s0;
    assign s0 = x[0] ^ y[0]; // x0 XOR y0
    assign sum[0] = s0 ^ 0; // sum0 = s0 XOR Cin (Cin = 0)
    assign c1 = (x[0] & y[0]) | (s0 & 0); // carry out of FA0

    // Full Adder 1
    wire s1;
    assign s1 = x[1] ^ y[1]; // x1 XOR y1
    assign sum[1] = s1 ^ c1; // sum1 = s1 XOR c1
    assign c2 = (x[1] & y[1]) | (s1 & c1); // carry out of FA1

    // Full Adder 2
    wire s2;
    assign s2 = x[2] ^ y[2]; // x2 XOR y2
    assign sum[2] = s2 ^ c2; // sum2 = s2 XOR c2
    assign c3 = (x[2] & y[2]) | (s2 & c2); // carry out of FA2

    // Full Adder 3
    wire s3;
    assign s3 = x[3] ^ y[3]; // x3 XOR y3
    assign sum[3] = s3 ^ c3; // sum3 = s3 XOR c3
    assign sum[4] = (x[3] & y[3]) | (s3 & c3); // carry out of FA3 is overflow

endmodule