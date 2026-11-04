module top_module (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire c1, c2, c3;

    // Full Adder 0
    wire s0, cout0;
    assign s0 = x[0] ^ y[0];
    assign sum[0] = s0 ^ 0; // Cin is 0 for the first adder
    assign cout0 = (x[0] & y[0]) | (s0 & 0);

    // Full Adder 1
    wire s1, cout1;
    assign s1 = x[1] ^ y[1];
    assign sum[1] = s1 ^ cout0;
    assign cout1 = (x[1] & y[1]) | (s1 & cout0);

    // Full Adder 2
    wire s2, cout2;
    assign s2 = x[2] ^ y[2];
    assign sum[2] = s2 ^ cout1;
    assign cout2 = (x[2] & y[2]) | (s2 & cout1);

    // Full Adder 3
    wire s3;
    assign s3 = x[3] ^ y[3];
    assign sum[3] = s3 ^ cout2;
    assign sum[4] = (x[3] & y[3]) | (s3 & cout2); // Overflow bit

endmodule