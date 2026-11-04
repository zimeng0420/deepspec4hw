module top_module (
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);

    genvar i;
    
    // (1) out_both: out_both[i] should be '1' if both in[i] and in[i+1] are '1'
    generate
        for (i = 0; i < 99; i = i + 1) begin : gen_out_both
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate
    
    // (2) out_any: out_any[i] should be '1' if any of in[i] or in[i-1] are '1'
    generate
        for (i = 1; i < 100; i = i + 1) begin : gen_out_any
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate
    
    // (3) out_different: out_different[i] should be '1' if in[i] is different than in[i+1]
    generate
        for (i = 0; i < 99; i = i + 1) begin : gen_out_different
            assign out_different[i] = in[i] ^ in[i+1];
        end
        // Wrap around case for in[99]
        assign out_different[99] = in[99] ^ in[0];
    endgenerate

endmodule