module top_module (
	input [254:0] in,
	output reg [7:0] out
);

  // Use a ripple carry adder-like approach for simplicity and clarity
  // This is a straightforward implementation suitable for synthesis.

  reg [7:0] count_intermediate [0:31]; // Array to hold intermediate sums

  // Stage 1: Count groups of 8 bits (255/8 = 31.875, so we need 32 sums)
  always @(*) begin
    for (integer i = 0; i < 32; i = i + 1) begin
      count_intermediate[i] = 0;
      for (integer j = 0; j < 8; j = j + 1) begin
        if ((i * 8 + j) < 255) begin
          count_intermediate[i] = count_intermediate[i] + in[i * 8 + j]; // Directly add bits
        end
      end
    end
  end


  // Stage 2: Add intermediate sums.  This stage aggregates the counts.
  // Note: This could be optimized further, e.g., with a tree-based adder, 
  // especially for a very large input.  However, for 255 bits, this is simple and efficient.

  always @(*) begin
    out = 0;
    for (integer i = 0; i < 32; i = i + 1) begin
      out = out + count_intermediate[i];
    end
  end

endmodule