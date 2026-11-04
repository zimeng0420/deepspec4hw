module top_module (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;
    assign out_or = |in;

    wire xor_intermediate[49:0];
    genvar i;

    generate
        for (i = 0; i < 50; i = i + 1) begin : xor_pairs
            assign xor_intermediate[i] = in[2*i] ^ in[2*i+1];
        end
    endgenerate

    wire xor_intermediate2[24:0];

    generate
        for (i = 0; i < 25; i = i + 1) begin : xor_pairs2
            assign xor_intermediate2[i] = xor_intermediate[2*i] ^ xor_intermediate[2*i+1];
        end
    endgenerate

    wire xor_intermediate3[11:0];

    generate
        for (i = 0; i < 12; i = i + 1) begin : xor_pairs3
            if (i < 11)
                assign xor_intermediate3[i] = xor_intermediate2[2*i] ^ xor_intermediate2[2*i+1];
            else
                assign xor_intermediate3[i] = xor_intermediate2[2*i];
        end
    endgenerate

    wire xor_intermediate4[5:0];

    generate
        for (i = 0; i < 6; i = i + 1) begin : xor_pairs4
            if (i < 5)
                assign xor_intermediate4[i] = xor_intermediate3[2*i] ^ xor_intermediate3[2*i+1];
            else
                assign xor_intermediate4[i] = xor_intermediate3[2*i];
        end
    endgenerate

    wire xor_intermediate5[2:0];

    generate
        for (i = 0; i < 3; i = i + 1) begin : xor_pairs5
            if (i < 2)
                assign xor_intermediate5[i] = xor_intermediate4[2*i] ^ xor_intermediate4[2*i+1];
            else
                assign xor_intermediate5[i] = xor_intermediate4[2*i];
        end
    endgenerate

    wire xor_intermediate6;
    assign xor_intermediate6 = xor_intermediate5[0] ^ xor_intermediate5[1];

    assign out_xor = xor_intermediate6 ^ xor_intermediate5[2];

endmodule