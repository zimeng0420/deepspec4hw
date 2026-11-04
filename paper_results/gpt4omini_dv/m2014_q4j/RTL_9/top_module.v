module top_module (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire c1, c2, c3; // Carry wires

    // Full Adder 0
    wire sum0;
    assign sum0 = x[0] ^ y[0]; // Sum of LSB
    assign sum[0] = sum0 ^ 1'b0; // No carry-in for the first bit
    assign c1 = (x[0] & y[0]); // Carry-out from LSB

    // Full Adder 1
    wire sum1;
    assign sum1 = x[1] ^ y[1]; // Sum of second bit
    assign sum[1] = sum1 ^ c1; // Carry-in is c1
    assign c2 = (sum1 & c1) | (x[1] & y[1]); // Carry-out from second bit

    // Full Adder 2
    wire sum2;
    assign sum2 = x[2] ^ y[2]; // Sum of third bit
    assign sum[2] = sum2 ^ c2; // Carry-in is c2
    assign c3 = (sum2 & c2) | (x[2] & y[2]); // Carry-out from third bit

    // Full Adder 3
    wire sum3;
    assign sum3 = x[3] ^ y[3]; // Sum of MSB
    assign sum[3] = sum3 ^ c3; // Carry-in is c3
    assign sum[4] = (sum3 & c3) | (x[3] & y[3]); // Carry-out indicates overflow

endmodule