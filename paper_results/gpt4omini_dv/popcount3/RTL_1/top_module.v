module top_module (
    input [2:0] in,
    output [1:0] out
);

    assign out[0] = (in[0] ^ in[1] ^ in[2]); // Count of 1's in the least significant bit
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]); // Count of pairs of 1's

endmodule