module top_module (
    input  [254:0] in,
    output reg [7:0] out
);

    // Internal signals
    wire [7:0] segment_counts [31:0]; // Array to store counts for 8-bit segments
    wire [7:0] intermediate_sums [3:0]; // Intermediate sums for the adder tree

    // Calculate population count for each 8-bit segment
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: segment_loop
            // Handle the last 7 bits separately
            if (i == 31) begin
                assign segment_counts[i] = {1'b0, in[254:248]} + {1'b0, in[247:240]}; // Combine last two segments
            end
             else begin
                assign segment_counts[i] =  in[i*8+7:i*8] + in[i*8+6:i*8] + in[i*8+5:i*8] + in[i*8+4:i*8] + in[i*8+3:i*8] + in[i*8+2:i*8] + in[i*8+1:i*8] + in[i*8+0:i*8];
            end
        end
    endgenerate

    // Adder Tree - First Level (Reduce 32 segments to 16 sums)
    assign intermediate_sums[0] = segment_counts[0] + segment_counts[1];
    assign intermediate_sums[1] = segment_counts[2] + segment_counts[3];
    assign intermediate_sums[2] = segment_counts[4] + segment_counts[5];
    assign intermediate_sums[3] = segment_counts[6] + segment_counts[7];
    assign intermediate_sums[4] = segment_counts[8] + segment_counts[9];
    assign intermediate_sums[5] = segment_counts[10] + segment_counts[11];
    assign intermediate_sums[6] = segment_counts[12] + segment_counts[13];
    assign intermediate_sums[7] = segment_counts[14] + segment_counts[15];
    assign intermediate_sums[8] = segment_counts[16] + segment_counts[17];
    assign intermediate_sums[9] = segment_counts[18] + segment_counts[19];
    assign intermediate_sums[10] = segment_counts[20] + segment_counts[21];
    assign intermediate_sums[11] = segment_counts[22] + segment_counts[23];
    assign intermediate_sums[12] = segment_counts[24] + segment_counts[25];
    assign intermediate_sums[13] = segment_counts[26] + segment_counts[27];
    assign intermediate_sums[14] = segment_counts[28] + segment_counts[29];
    assign intermediate_sums[15] = segment_counts[30] + segment_counts[31];

    // Adder Tree - Second Level (Reduce 16 sums to 8)
    wire [7:0] intermediate_sums2 [7:0];

    assign intermediate_sums2[0] = intermediate_sums[0] + intermediate_sums[1];
    assign intermediate_sums2[1] = intermediate_sums[2] + intermediate_sums[3];
    assign intermediate_sums2[2] = intermediate_sums[4] + intermediate_sums[5];
    assign intermediate_sums2[3] = intermediate_sums[6] + intermediate_sums[7];
    assign intermediate_sums2[4] = intermediate_sums[8] + intermediate_sums[9];
    assign intermediate_sums2[5] = intermediate_sums[10] + intermediate_sums[11];
    assign intermediate_sums2[6] = intermediate_sums[12] + intermediate_sums[13];
    assign intermediate_sums2[7] = intermediate_sums[14] + intermediate_sums[15];

    // Adder Tree - Third Level (Reduce 8 sums to 4)
    wire [7:0] intermediate_sums3 [3:0];

    assign intermediate_sums3[0] = intermediate_sums2[0] + intermediate_sums2[1];
    assign intermediate_sums3[1] = intermediate_sums2[2] + intermediate_sums2[3];
    assign intermediate_sums3[2] = intermediate_sums2[4] + intermediate_sums2[5];
    assign intermediate_sums3[3] = intermediate_sums2[6] + intermediate_sums2[7];

     // Adder Tree - Fourth Level (Reduce 4 sums to 2)
    wire [7:0] intermediate_sums4 [1:0];

    assign intermediate_sums4[0] = intermediate_sums3[0] + intermediate_sums3[1];
    assign intermediate_sums4[1] = intermediate_sums3[2] + intermediate_sums3[3];

     // Adder Tree - Fifth Level (Reduce 2 sums to 1)
    wire [7:0] final_sum;
    assign final_sum = intermediate_sums4[0] + intermediate_sums4[1];
    // Assign the final result to the output register
    always @(*) begin
        out = final_sum;
    end

endmodule