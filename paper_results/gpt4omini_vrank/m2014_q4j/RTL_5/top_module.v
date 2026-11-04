module top_module (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire c1, c2, c3; // carry wires

    // Full adder for bit 0
    wire s0 = x[0] ^ y[0];
    assign sum[0] = s0 ^ 0; // no carry to add
    assign c1 = (x[0] & y[0]) | (s0 & 0); // carry out

    // Full adder for bit 1
    wire s1 = x[1] ^ y[1];
    assign sum[1] = s1 ^ c1;
    assign c2 = (x[1] & y[1]) | (s1 & c1);

    // Full adder for bit 2
    wire s2 = x[2] ^ y[2];
    assign sum[2] = s2 ^ c2;
    assign c3 = (x[2] & y[2]) | (s2 & c2);
    
    // Full adder for bit 3
    wire s3 = x[3] ^ y[3];
    assign sum[3] = s3 ^ c3;
    assign sum[4] = (x[3] & y[3]) | (s3 & c3); // overflow bit
endmodule