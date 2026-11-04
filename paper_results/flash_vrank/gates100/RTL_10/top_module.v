module top_module (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;
    assign out_or = |in;

    wire [99:0] xor_tree;
    assign xor_tree[0] = in[0];
    genvar i;
    generate
        for (i = 1; i < 100; i = i + 1) begin : xor_loop
            assign xor_tree[i] = xor_tree[i-1] ^ in[i];
        end
    endgenerate

    assign out_xor = xor_tree[99];

endmodule