module top_module (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire c1, c2, c3;

    // Full Adder for the least significant bit
    assign sum[0] = x[0] ^ y[0]; // S0
    assign c1 = (x[0] & y[0]); // C0
    
    // Full Adder for the second bit
    assign sum[1] = x[1] ^ y[1] ^ c1; // S1
    assign c2 = (x[1] & y[1]) | (c1 & (x[1] ^ y[1])); // C1
    
    // Full Adder for the third bit
    assign sum[2] = x[2] ^ y[2] ^ c2; // S2
    assign c3 = (x[2] & y[2]) | (c2 & (x[2] ^ y[2])); // C2
    
    // Full Adder for the most significant bit
    assign sum[3] = x[3] ^ y[3] ^ c3; // S3
    assign sum[4] = (x[3] & y[3]) | (c3 & (x[3] ^ y[3])); // Overflow bit

endmodule