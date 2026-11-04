module top_module (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire c1, c2, c3; // Carry wires

    // Full Adder 0
    wire s0, c0;
    assign s0 = x[0] ^ y[0]; // Sum for the least significant bit
    assign c0 = (x[0] & y[0]);

    // Full Adder 1
    wire s1, c1_temp;
    assign s1 = s0 ^ c1; // Sum for the second bit, using carry from FA0
    assign c1_temp = (s0 & c1) | (x[1] & y[1]);
    assign c1 = c1_temp;

    // Full Adder 2
    wire s2, c2_temp;
    assign s2 = c1 ^ x[2] ^ y[2]; // Sum for the third bit
    assign c2_temp = (c1 & (x[2] ^ y[2])) | (x[2] & y[2]);
    assign c2 = c2_temp;

    // Full Adder 3
    wire s3, c3_temp;
    assign s3 = c2 ^ x[3] ^ y[3]; // Sum for the most significant bit
    assign c3_temp = (c2 & (x[3] ^ y[3])) | (x[3] & y[3]);
    assign c3 = c3_temp;

    // Final Sum Output
    assign sum[0] = s0;
    assign sum[1] = s1;
    assign sum[2] = s2;
    assign sum[3] = s3;
    assign sum[4] = c3; // Overflow bit

endmodule