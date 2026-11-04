module top_module (
    input [254:0] in,
    output reg [7:0] out
);

  wire [127:0] stage1_sums;
  wire [63:0] stage2_sums;
  wire [31:0] stage3_sums;
  wire [15:0] stage4_sums;
  wire [7:0] stage5_sums;
  wire [3:0] stage6_sums;
  wire [1:0] stage7_sums;
  wire [2:0] stage8_sum; // Last stage before output

  // Stage 1: Bit-Pair Summation (Half Adders)
  genvar i;
  generate
    for (i = 0; i < 127; i = i + 1) begin : half_adder_stage1
      assign stage1_sums[i] = in[2*i] + in[2*i+1];
    end
    assign stage1_sums[127] = in[254] + 1'b0; // Pad with 0
  endgenerate

  // Stage 2: 2-bit Adders
  generate
    for (i = 0; i < 63; i = i + 1) begin : adder_stage2
      assign stage2_sums[i] = stage1_sums[2*i] + stage1_sums[2*i+1];
    end
  endgenerate

  // Stage 3: 3-bit Adders
  generate
    for (i = 0; i < 31; i = i + 1) begin : adder_stage3
      assign stage3_sums[i] = stage2_sums[2*i] + stage2_sums[2*i+1];
    end
    assign stage3_sums[31] = stage2_sums[62] + stage2_sums[63];
  endgenerate

  // Stage 4: 4-bit Adders
  generate
    for (i = 0; i < 15; i = i + 1) begin : adder_stage4
      assign stage4_sums[i] = stage3_sums[2*i] + stage3_sums[2*i+1];
    end
    assign stage4_sums[15] = stage3_sums[30] + stage3_sums[31];
  endgenerate

  // Stage 5: 5-bit Adders
  generate
    for (i = 0; i < 7; i = i + 1) begin : adder_stage5
      assign stage5_sums[i] = stage4_sums[2*i] + stage4_sums[2*i+1];
    end
    assign stage5_sums[7] = stage4_sums[14] + stage4_sums[15];
  endgenerate

  // Stage 6: 6-bit Adders
  generate
    for (i = 0; i < 3; i = i + 1) begin : adder_stage6
      assign stage6_sums[i] = stage5_sums[2*i] + stage5_sums[2*i+1];
    end
    assign stage6_sums[3] = stage5_sums[6] + stage5_sums[7];
  endgenerate

  // Stage 7: 7-bit Adders
  generate
    for (i = 0; i < 1; i = i + 1) begin : adder_stage7
      assign stage7_sums[i] = stage6_sums[2*i] + stage6_sums[2*i+1];
    end
    assign stage7_sums[1] = stage6_sums[2] + stage6_sums[3];
  endgenerate

  // Stage 8: 8-bit Adder
  assign stage8_sum = stage7_sums[0] + stage7_sums[1];

  // Final Stage: Assign to output
  always @(*) begin
    out = stage8_sum;
  end

endmodule