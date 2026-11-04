module top_module (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire c1, c2, c3; // carry-out signals

    // Full Adder 0
    assign sum[0] = x[0] ^ y[0]; // Sum for least significant bit
    assign c1 = (x[0] & y[0]); // Carry-out for least significant bit

    // Full Adder 1
    assign sum[1] = x[1] ^ y[1] ^ c1; // Sum for second bit
    assign c2 = (x[1] & y[1]) | (c1 & (x[1] ^ y[1])); // Carry-out for second bit

    // Full Adder 2
    assign sum[2] = x[2] ^ y[2] ^ c2; // Sum for third bit
    assign c3 = (x[2] & y[2]) | (c2 & (x[2] ^ y[2])); // Carry-out for third bit

    // Full Adder 3
    assign sum[3] = x[3] ^ y[3] ^ c3; // Sum for most significant bit
    assign sum[4] = (x[3] & y[3]) | (c3 & (x[3] ^ y[3])); // Carry-out for most significant bit (overflow)

endmodule