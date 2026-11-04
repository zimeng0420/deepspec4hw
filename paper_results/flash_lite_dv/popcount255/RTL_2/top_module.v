module top_module (
    input  [254:0] in,
    output reg [7:0] out
);

    // Internal wires for segment counts
    wire [7:0] seg_count [31:0]; // Assuming 8-bit segments (256 / 8 = 32 segments)
    wire [7:0] count1, count2;

    // Calculate population count for each 8-bit segment
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: segment_counter
            // Extract 8-bit segment, handling the last 3 bits (255 bit total)
            if (i < 31) begin
                assign seg_count[i] = {in[i*8+7], in[i*8+6], in[i*8+5], in[i*8+4], in[i*8+3], in[i*8+2], in[i*8+1], in[i*8+0]} +
                                      {in[i*8+7], in[i*8+6], in[i*8+5], in[i*8+4], in[i*8+3], in[i*8+2], in[i*8+1], in[i*8+0]} +
                                      {in[i*8+7], in[i*8+6], in[i*8+5], in[i*8+4], in[i*8+3], in[i*8+2], in[i*8+1], in[i*8+0]} +
                                      {in[i*8+7], in[i*8+6], in[i*8+5], in[i*8+4], in[i*8+3], in[i*8+2], in[i*8+1], in[i*8+0]};

            end else begin // Last segment (3 bits)
                assign seg_count[i] = in[254] + in[253] + in[252];
            end

        end
    endgenerate

    // Adder Tree (Simplified for this example)
    // Add segment counts in a hierarchical manner
    assign count1 = seg_count[0] + seg_count[1] + seg_count[2] + seg_count[3] + seg_count[4] + seg_count[5] + seg_count[6] + seg_count[7];
    assign count2 = seg_count[8] + seg_count[9] + seg_count[10] + seg_count[11] + seg_count[12] + seg_count[13] + seg_count[14] + seg_count[15];
    assign out = count1 + count2 + seg_count[16] + seg_count[17] + seg_count[18] + seg_count[19] + seg_count[20] + seg_count[21] + seg_count[22] + seg_count[23] + seg_count[24] + seg_count[25] + seg_count[26] + seg_count[27] + seg_count[28] + seg_count[29] + seg_count[30] + {5'b0, seg_count[31]};


endmodule