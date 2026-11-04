module top_module (
    input [254:0] in,
    output reg [7:0] out
);

    wire [1:0] count[0:63];
    wire [7:0] sum;

    // Sub-counters for groups of 4 bits
    genvar i;
    generate
        for (i = 0; i < 63; i = i + 1) begin : sub_counters
            always @(*) begin
                count[i] = in[i*4] + in[i*4+1] + in[i*4+2] + in[i*4+3];
            end
        end
    endgenerate

    // Sub-counter for the remaining 3 bits
    always @(*) begin
        count[63] = in[252] + in[253] + in[254];
    end

    // Adder Tree
    assign sum = count[0] + count[1] + count[2] + count[3] + count[4] + count[5] + count[6] + count[7] +
                 count[8] + count[9] + count[10] + count[11] + count[12] + count[13] + count[14] + count[15] +
                 count[16] + count[17] + count[18] + count[19] + count[20] + count[21] + count[22] + count[23] +
                 count[24] + count[25] + count[26] + count[27] + count[28] + count[29] + count[30] + count[31] +
                 count[32] + count[33] + count[34] + count[35] + count[36] + count[37] + count[38] + count[39] +
                 count[40] + count[41] + count[42] + count[43] + count[44] + count[45] + count[46] + count[47] +
                 count[48] + count[49] + count[50] + count[51] + count[52] + count[53] + count[54] + count[55] +
                 count[56] + count[57] + count[58] + count[59] + count[60] + count[61] + count[62] + count[63];

    always @(*) begin
        out = sum;
    end

endmodule