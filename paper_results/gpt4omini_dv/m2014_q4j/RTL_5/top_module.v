module top_module (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire c1, c2, c3; // Carry wires between full adders

    // Full Adder 0
    wire s0, cout0;
    assign s0 = x[0] ^ y[0];
    assign sum[0] = s0 ^ 0; // First bit with Carry-in = 0
    assign cout0 = (x[0] & y[0]) | (s0 & 0); // Carry-out from FA0

    // Full Adder 1
    wire s1, cout1;
    assign s1 = x[1] ^ y[1];
    assign sum[1] = s1 ^ cout0; // Second bit with Carry-in = cout0
    assign cout1 = (x[1] & y[1]) | (s1 & cout0); // Carry-out from FA1

    // Full Adder 2
    wire s2, cout2;
    assign s2 = x[2] ^ y[2];
    assign sum[2] = s2 ^ cout1; // Third bit with Carry-in = cout1
    assign cout2 = (x[2] & y[2]) | (s2 & cout1); // Carry-out from FA2

    // Full Adder 3
    wire s3;
    assign s3 = x[3] ^ y[3];
    assign sum[3] = s3 ^ cout2; // Fourth bit with Carry-in = cout2
    assign sum[4] = (x[3] & y[3]) | (s3 & cout2); // Carry-out for overflow

endmodule