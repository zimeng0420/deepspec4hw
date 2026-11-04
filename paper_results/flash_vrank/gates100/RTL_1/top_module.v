module top_module (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;
    assign out_or = |in;

    // XOR reduction can be done using a loop or a cascade of XORs.
    // Since a single XOR operator only takes two inputs, we can cascade them.
    // This is equivalent to XOR-ing all bits together.

    wire [98:0] xor_cascade;
    assign xor_cascade[0] = in[0] ^ in[1];
    generate 
        genvar i;
        for (i=1; i<99; i=i+1) begin
            assign xor_cascade[i] = xor_cascade[i-1] ^ in[i+1];
        end
    endgenerate
    assign out_xor = xor_cascade[98];

endmodule