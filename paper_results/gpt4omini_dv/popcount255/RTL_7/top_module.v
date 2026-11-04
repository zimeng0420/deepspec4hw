module top_module (
    input [254:0] in,
    output reg [7:0] out
);

    wire [8:0] count [31:0]; // Intermediate counts
    wire [7:0] sum [7:0];    // Stage sums

    // Stage 1: Count pairs of bits
    genvar i;
    generate
        for (i = 0; i < 255; i = i + 2) begin : stage1
            assign count[i/2] = in[i] + in[i+1];
        end
    endgenerate

    // Stage 2: Sum counts of previous stage
    generate
        for (i = 0; i < 128; i = i + 2) begin : stage2
            assign sum[i/2] = count[i] + count[i+1];
        end
    endgenerate

    // Stage 3: Sum counts of Stage 2
    generate
        for (i = 0; i < 64; i = i + 2) begin : stage3
            assign sum[i/2 + 64] = sum[i] + sum[i+1];
        end
    endgenerate

    // Stage 4: Sum counts of Stage 3
    generate
        for (i = 0; i < 32; i = i + 2) begin : stage4
            assign sum[i/2 + 128] = sum[i] + sum[i+1];
        end
    endgenerate

    // Stage 5: Sum counts of Stage 4
    generate
        for (i = 0; i < 16; i = i + 2) begin : stage5
            assign sum[i/2 + 192] = sum[i] + sum[i+1];
        end
    endgenerate

    // Stage 6: Sum counts of Stage 5
    generate
        for (i = 0; i < 8; i = i + 2) begin : stage6
            assign sum[i/2 + 224] = sum[i] + sum[i+1];
        end
    endgenerate

    // Stage 7: Final sum
    assign out = sum[0] + sum[1] + sum[2] + sum[3] + sum[4] + sum[5] + sum[6] + sum[7];

endmodule