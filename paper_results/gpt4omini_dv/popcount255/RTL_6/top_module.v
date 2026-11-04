module top_module (
    input [254:0] in,
    output reg [7:0] out
);

    reg [7:0] count [31:0]; // Intermediate counts for each group
    integer i;

    always @(*) begin
        // Compute population count in stages
        // Stage 1: Count pairs of bits
        for (i = 0; i < 255; i = i + 2) begin
            count[i/2] = (in[i] + in[i+1]); // Count pairs
        end
        
        // Stage 2: Count groups of 4
        for (i = 0; i < 128; i = i + 4) begin
            count[16 + (i/4)] = count[i/2] + count[i/2 + 1] + count[i/2 + 2] + count[i/2 + 3];
        end
        
        // Stage 3: Count groups of 8
        for (i = 0; i < 64; i = i + 8) begin
            count[24 + (i/8)] = count[16 + (i/4)] + count[16 + (i/4) + 1] + count[16 + (i/4) + 2] + count[16 + (i/4) + 3];
        end

        // Stage 4: Final count
        out = count[0] + count[1] + count[2] + count[3] + count[4] + count[5] + count[6] + count[7] + 
              count[8] + count[9] + count[10] + count[11] + count[12] + count[13] + count[14] + count[15] +
              count[16] + count[17] + count[18] + count[19] + count[20] + count[21] + count[22] + count[23] +
              count[24] + count[25] + count[26] + count[27] + count[28] + count[29] + count[30] + count[31];
    end
endmodule