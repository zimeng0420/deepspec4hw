module top_module (
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);

    // (1) out_both: Check if both in[i] and in[i+1] are 1
    assign out_both = in[98:0] & in[99:1];
    
    // (2) out_any: Check if either in[i] or in[i-1] are 1
    assign out_any = in[99:1] | in[98:0];
    
    // (3) out_different: Check if in[i] is different from in[i+1] with wrap around
    assign out_different = in ^ {in[0], in[99:1]};

endmodule