module top_module (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;  // AND: All bits must be 1 for output to be 1.
    assign out_or  = |in;  // OR:  Any bit being 1 causes the output to be 1.

    wire [99:0] xor_chain;
    assign xor_chain[0] = in[0];
    generate
        genvar i;
        for (i = 1; i < 100; i = i + 1) begin
            assign xor_chain[i] = xor_chain[i-1] ^ in[i];
        end
    endgenerate
    assign out_xor = xor_chain[99];


endmodule