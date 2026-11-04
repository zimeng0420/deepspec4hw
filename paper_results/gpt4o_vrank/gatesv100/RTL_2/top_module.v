module top_module (
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);

    // out_both: Check if both in[n] and in[n+1] are 1
    generate
        genvar i;
        for (i = 0; i < 99; i = i + 1) begin : gen_both
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate

    // out_any: Check if either in[n] or in[n-1] is 1
    generate
        for (i = 1; i < 100; i = i + 1) begin : gen_any
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate

    // out_different: Check if in[n] is different from in[(n+1)%100]
    generate
        for (i = 0; i < 99; i = i + 1) begin : gen_different
            assign out_different[i] = in[i] ^ in[i+1];
        end
        assign out_different[99] = in[99] ^ in[0];
    endgenerate

endmodule