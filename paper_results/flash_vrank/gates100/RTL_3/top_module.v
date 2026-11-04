module top_module (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;
    assign out_or = |in;

    wire xor_intermediate_1 [49:0];
    wire xor_intermediate_2 [24:0];
    wire xor_intermediate_3 [11:0];
    wire xor_intermediate_4 [5:0];
    wire xor_intermediate_5 [2:0];

    genvar i;

    generate
        for (i = 0; i < 50; i = i + 1) begin : xor_stage_1
            assign xor_intermediate_1[i] = in[2*i] ^ in[2*i+1];
        end
    endgenerate

    generate
        for (i = 0; i < 25; i = i + 1) begin : xor_stage_2
            assign xor_intermediate_2[i] = xor_intermediate_1[2*i] ^ xor_intermediate_1[2*i+1];
        end
    endgenerate

    generate
        for (i = 0; i < 12; i = i + 1) begin : xor_stage_3
           if (i < 11)
             assign xor_intermediate_3[i] = xor_intermediate_2[2*i] ^ xor_intermediate_2[2*i+1];
           else
             assign xor_intermediate_3[i] = xor_intermediate_2[2*i];
        end
    endgenerate

    generate
        for (i = 0; i < 6; i = i + 1) begin : xor_stage_4
            if (i < 5)
                assign xor_intermediate_4[i] = xor_intermediate_3[2*i] ^ xor_intermediate_3[2*i+1];
            else
                assign xor_intermediate_4[i] = xor_intermediate_3[2*i];
        end
    endgenerate

    generate
        for (i = 0; i < 3; i = i + 1) begin : xor_stage_5
           if (i < 2)
             assign xor_intermediate_5[i] = xor_intermediate_4[2*i] ^ xor_intermediate_4[2*i+1];
           else
             assign xor_intermediate_5[i] = xor_intermediate_4[2*i];

        end
    endgenerate
    
    assign out_xor = xor_intermediate_5[0] ^ xor_intermediate_5[1] ^ xor_intermediate_5[2];

endmodule