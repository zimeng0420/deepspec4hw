module top_module (
    input [2:0] in,
    output [1:0] out
);

    assign out[0] = in[0] ^ in[1] ^ in[2]; // modulo-2 addition to count 1's
    assign out[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]); // for counting pairs of 1's

endmodule