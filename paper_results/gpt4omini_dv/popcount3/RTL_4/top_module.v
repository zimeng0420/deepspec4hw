module top_module (
    input [2:0] in,
    output [1:0] out
);
    assign out[0] = in[0] ^ in[1] ^ in[2]; // Sum of 1's modulo 2
    assign out[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]); // Sum of 1's divided by 2
endmodule