module top_module (
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [3:0] c; // carry bits
    wire [3:0] s; // sum bits
    
    // Full adder for each bit
    assign s[0] = x[0] ^ y[0];
    assign c[0] = x[0] & y[0];

    assign s[1] = x[1] ^ y[1] ^ c[0];
    assign c[1] = (x[1] & y[1]) | (c[0] & (x[1] ^ y[1]));

    assign s[2] = x[2] ^ y[2] ^ c[1];
    assign c[2] = (x[2] & y[2]) | (c[1] & (x[2] ^ y[2]));
    
    assign s[3] = x[3] ^ y[3] ^ c[2];
    assign c[3] = (x[3] & y[3]) | (c[2] & (x[3] ^ y[3]));
    
    // Output sum including overflow bit
    assign sum = {c[3], s};

endmodule