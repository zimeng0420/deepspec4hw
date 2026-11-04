module top_module (
    input  [254:0] in,
    output reg [7:0] out
);

  // Internal signals
  wire [7:0] segment_counts [31:0]; // 32 segments of 8 bits each
  wire [7:0] sum1;
  wire [7:0] sum2;
  wire [7:0] sum3;
  wire [7:0] sum4;
  wire [7:0] sum5;
  wire [7:0] sum6;
  wire [7:0] sum7;

  // Segment population count modules (using LUT approach for 8-bit segments)
  generate
    genvar i;
    for (i = 0; i < 32; i = i + 1) begin: segment_counter
      wire [7:0] segment_in;
      assign segment_in = (i == 31) ? {1'b0, in[254:247]} : in[(i+1)*8-1:i*8];

      // Instantiate 8-bit population count module (or use built-in if available in your synthesis tool)
      popcount_8bit popcount_inst (
        .in(segment_in),
        .out(segment_counts[i])
      );
    end
  endgenerate

  // Adder tree
  // Level 1: Sum of adjacent segment counts (32 -> 16)
  assign sum1 = segment_counts[0] + segment_counts[1];
  assign sum2 = segment_counts[2] + segment_counts[3];
  assign sum3 = segment_counts[4] + segment_counts[5];
  assign sum4 = segment_counts[6] + segment_counts[7];
  assign sum5 = segment_counts[8] + segment_counts[9];
  assign sum6 = segment_counts[10] + segment_counts[11];
  assign sum7 = segment_counts[12] + segment_counts[13];
  assign sum8 = segment_counts[14] + segment_counts[15];
  assign sum9 = segment_counts[16] + segment_counts[17];
  assign sum10 = segment_counts[18] + segment_counts[19];
  assign sum11 = segment_counts[20] + segment_counts[21];
  assign sum12 = segment_counts[22] + segment_counts[23];
  assign sum13 = segment_counts[24] + segment_counts[25];
  assign sum14 = segment_counts[26] + segment_counts[27];
  assign sum15 = segment_counts[28] + segment_counts[29];
  assign sum16 = segment_counts[30] + segment_counts[31];
  // Level 2: Sum of results from level 1 (16 -> 8)
  wire [7:0] sum17;
  wire [7:0] sum18;
  wire [7:0] sum19;
  wire [7:0] sum20;
  assign sum17 = sum1 + sum2;
  assign sum18 = sum3 + sum4;
  assign sum19 = sum5 + sum6;
  assign sum20 = sum7 + sum8;
  assign sum21 = sum9 + sum10;
  assign sum22 = sum11 + sum12;
  assign sum23 = sum13 + sum14;
  assign sum24 = sum15 + sum16;
    // Level 3: Sum of results from level 2 (8 -> 4)
  wire [7:0] sum25;
  wire [7:0] sum26;
  assign sum25 = sum17 + sum18;
  assign sum26 = sum19 + sum20;
  assign sum27 = sum21 + sum22;
  assign sum28 = sum23 + sum24;
    // Level 4: Sum of results from level 3 (4 -> 2)
  wire [7:0] sum29;
  wire [7:0] sum30;
  assign sum29 = sum25 + sum26;
  assign sum30 = sum27 + sum28;

  // Level 5: Sum of results from level 4 (2 -> 1)
  wire [7:0] sum31;
  assign sum31 = sum29 + sum30;

  // Assign final result
  always @(*) begin
    out = sum31;
  end

endmodule

// 8-bit population count module (using a simple adder)
module popcount_8bit (
    input  [7:0] in,
    output reg [7:0] out
);

  always @(*) begin
    out = in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7];
  end
endmodule