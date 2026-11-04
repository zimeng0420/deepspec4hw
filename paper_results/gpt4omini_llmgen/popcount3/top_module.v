module top_module (
    input [2:0] in,
    output [1:0] out
);
    assign out = in[0] + in[1] + in[2];  // Sum of bits to count the number of '1's
endmodule