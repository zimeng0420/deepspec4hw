module top_module (
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);

    // (1) out_both: Both in[i] and in[i+1] must be '1' (valid for i=0 to 98)
    assign out_both = in[98:0] & in[99:1];

    // (2) out_any: Either in[i] or in[i-1] must be '1' (valid for i=1 to 99)
    assign out_any = in[99:1] | in[98:0];

    // (3) out_different: in[i] is different from its left neighbour, wrapping in[0] with in[99]
    assign out_different = in ^ {in[0], in[99:1]};

endmodule