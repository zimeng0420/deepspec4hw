module top_module (
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);

    // Compute out_both: Each bit is 1 if both the corresponding input bit and its left neighbor are '1'
    assign out_both = in[98:0] & in[99:1];

    // Compute out_any: Each bit is 1 if any of the corresponding input bit or its right neighbor is '1'
    assign out_any = in[99:1] | in[98:0];

    // Compute out_different: Each bit is 1 if the corresponding input bit is different from its left neighbor
    assign out_different = in ^ {in[0], in[99:1]};

endmodule