module top_module (
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);

assign out_both[98] = in[98] & in[99];
assign out_any[99] = in[0] | in[1];
genvar i;
generate
    for (i = 0; i < 98; i = i + 1) begin : both_any
        assign out_both[i] = in[i] & in[i + 1];
        assign out_any[i] = in[i] | in[i + 1];
    end
endgenerate

assign out_different[0] = in[0] ^ in[99];
generate
    for (i = 1; i < 99; i = i + 1) begin : diff
        assign out_different[i] = in[i] ^ in[i - 1];
    end
endgenerate

endmodule