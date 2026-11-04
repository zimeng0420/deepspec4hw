module top_module (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;
    assign out_or = |in;

    // XOR reduction using a loop (or tree)

    wire [9:0] xor_stage1;
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : stage1
            assign xor_stage1[i] = in[i*10 + 0] ^ in[i*10 + 1] ^ in[i*10 + 2] ^ in[i*10 + 3] ^ in[i*10 + 4] ^ in[i*10 + 5] ^ in[i*10 + 6] ^ in[i*10 + 7] ^ in[i*10 + 8] ^ in[i*10 + 9];
        end
    endgenerate

    wire [4:0] xor_stage2;
    assign xor_stage2[0] = xor_stage1[0] ^ xor_stage1[1];
    assign xor_stage2[1] = xor_stage1[2] ^ xor_stage1[3];
    assign xor_stage2[2] = xor_stage1[4] ^ xor_stage1[5];
    assign xor_stage2[3] = xor_stage1[6] ^ xor_stage1[7];
    assign xor_stage2[4] = xor_stage1[8] ^ xor_stage1[9];


    wire [1:0] xor_stage3;
    assign xor_stage3[0] = xor_stage2[0] ^ xor_stage2[1];
    assign xor_stage3[1] = xor_stage2[2] ^ xor_stage2[3];

    assign out_xor = xor_stage3[0] ^ xor_stage3[1] ^ xor_stage2[4];


endmodule