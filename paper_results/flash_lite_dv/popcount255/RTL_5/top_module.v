module top_module (
    input  [254:0] in,
    output reg [7:0] out
);

  // Internal signals
  wire [7:0] segment_counts [31:0]; // Array to store population counts for 8-bit segments
  wire [7:0] intermediate_sums_1 [15:0]; // Intermediate sums for adder tree (level 1)
  wire [7:0] intermediate_sums_2 [7:0]; // Intermediate sums for adder tree (level 2)
  wire [7:0] intermediate_sums_3 [3:0]; // Intermediate sums for adder tree (level 3)
  wire [7:0] intermediate_sums_4 [1:0]; // Intermediate sums for adder tree (level 4)

  // Instance of the popcount8 module for each 8-bit segment.  
  // The input 'in' is sliced into 8-bit segments
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin: segment_popcount
      popcount8 popcount_inst (
        .in(in[i*8 +: 8]),
        .out(segment_counts[i])
      );
    end
  endgenerate

  // Adder tree - Level 1: Sum 2 adjacent segments
  generate
    for (i = 0; i < 16; i = i + 1) begin: adder_level1
      adder8 adder_level1_inst (
        .a(segment_counts[i*2]),
        .b(segment_counts[i*2+1]),
        .sum(intermediate_sums_1[i])
      );
    end
  endgenerate

  // Adder tree - Level 2: Sum 2 adjacent intermediate sums from level 1
  generate
    for (i = 0; i < 8; i = i + 1) begin: adder_level2
      adder8 adder_level2_inst (
        .a(intermediate_sums_1[i*2]),
        .b(intermediate_sums_1[i*2+1]),
        .sum(intermediate_sums_2[i])
      );
    end
  endgenerate

  // Adder tree - Level 3: Sum 2 adjacent intermediate sums from level 2
  generate
    for (i = 0; i < 4; i = i + 1) begin: adder_level3
      adder8 adder_level3_inst (
        .a(intermediate_sums_2[i*2]),
        .b(intermediate_sums_2[i*2+1]),
        .sum(intermediate_sums_3[i])
      );
    end
  endgenerate

  // Adder tree - Level 4: Sum 2 adjacent intermediate sums from level 3
  generate
    for (i = 0; i < 2; i = i + 1) begin: adder_level4
      adder8 adder_level4_inst (
        .a(intermediate_sums_3[i*2]),
        .b(intermediate_sums_3[i*2+1]),
        .sum(intermediate_sums_4[i])
      );
    end
  endgenerate

  // Final adder to sum the last two values
  adder8 final_adder (
      .a(intermediate_sums_4[0]),
      .b(intermediate_sums_4[1]),
      .sum(out)
  );

endmodule

// Module to count the population of an 8-bit input
module popcount8 (
  input  [7:0] in,
  output reg [2:0] out
);

  always @(*) begin
    out = in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7];
  end

endmodule

// 8-bit adder module
module adder8 (
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] sum
);

  always @(*) begin
    sum = a + b;
  end
endmodule