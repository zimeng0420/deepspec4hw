module top_module(
    input  [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);

    // out_both
    assign out_both = in[98:0] & in[99:1];

    // out_any
    assign out_any = in[99:1] | in[98:0];

    // out_different
    assign out_different[0] = in[0] ^ in[99];
    genvar i;
    generate
        for (i = 1; i < 100; i = i + 1) begin: diff_gen
            assign out_different[i] = in[i] ^ in[i-1];
        end
    endgenerate

endmodule