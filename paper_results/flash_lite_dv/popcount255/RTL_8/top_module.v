module top_module (
    input  [254:0] in,
    output reg [7:0] out
);

  // Internal Wires
  wire [7:0] segment_count [31:0]; // Array to hold population counts for each segment

  // 8-bit Segment Population Count Calculation (32 segments)
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin: segment_counter
      // Extract 8-bit segment
      wire [7:0] segment;
      if (i == 31) begin
        assign segment = {1'b0, in[254:248]}; // Handle the last 7 bits (padded with a 0)
      end else begin
        assign segment = in[(i+1)*8-1:i*8]; // Correct segment selection
      end

      // Calculate Population Count for each segment
      always @(*) begin
        segment_count[i] = 0;
        for (integer j = 0; j < 8; j = j + 1) begin
          segment_count[i] = segment_count[i] + segment[j];
        end
      end
    end
  endgenerate

  // Adder Tree to Sum Segment Counts
  wire [8:0] sum1;
  wire [8:0] sum2;
  wire [8:0] sum3;
  wire [8:0] sum4;

  //Stage 1
  assign sum1 = segment_count[0] + segment_count[1] + segment_count[2] + segment_count[3] + segment_count[4] + segment_count[5] + segment_count[6] + segment_count[7];
  assign sum2 = segment_count[8] + segment_count[9] + segment_count[10] + segment_count[11] + segment_count[12] + segment_count[13] + segment_count[14] + segment_count[15];
  assign sum3 = segment_count[16] + segment_count[17] + segment_count[18] + segment_count[19] + segment_count[20] + segment_count[21] + segment_count[22] + segment_count[23];
  assign sum4 = segment_count[24] + segment_count[25] + segment_count[26] + segment_count[27] + segment_count[28] + segment_count[29] + segment_count[30] + segment_count[31];

  //Stage 2
  wire [8:0] sum5;
  wire [8:0] sum6;

  assign sum5 = sum1 + sum2;
  assign sum6 = sum3 + sum4;

  //Stage 3
  wire [8:0] sum7;

  assign sum7 = sum5 + sum6;

  // Output Assignment
  always @(*) begin
    out = sum7[7:0]; // Truncate to 8 bits (max count is 255)
  end

endmodule