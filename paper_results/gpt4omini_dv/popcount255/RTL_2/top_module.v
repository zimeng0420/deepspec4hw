module top_module (
    input [254:0] in,
    output reg [7:0] out
);

    // Intermediate sums
    wire [7:0] sum_level1 [31:0];
    wire [7:0] sum_level2 [15:0];
    wire [7:0] sum_level3 [7:0];
    wire [7:0] sum_level4;

    // Level 1: Count pairs of bits
    genvar i;
    generate
        for (i = 0; i < 255; i = i + 2) begin : pair_count
            assign sum_level1[i/2] = in[i] + in[i+1];
        end
    endgenerate

    // Level 2: Aggregate counts of level 1
    generate
        for (i = 0; i < 32; i = i + 2) begin : group_count
            assign sum_level2[i/2] = sum_level1[i] + sum_level1[i+1];
        end
    endgenerate

    // Level 3: Aggregate counts of level 2
    generate
        for (i = 0; i < 16; i = i + 2) begin : aggregate_count
            assign sum_level3[i/2] = sum_level2[i] + sum_level2[i+1];
        end
    endgenerate

    // Level 4: Final aggregate count
    assign sum_level4 = sum_level3[0] + sum_level3[1] + sum_level3[2] + sum_level3[3] +
                        sum_level3[4] + sum_level3[5] + sum_level3[6] + sum_level3[7];

    // Output the final count
    always @(*) begin
        out = sum_level4;
    end

endmodule