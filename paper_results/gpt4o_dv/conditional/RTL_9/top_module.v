module top_module (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

    always @(*) begin
        reg [7:0] min1;
        reg [7:0] min2;

        // First Stage: Pairwise Comparisons
        min1 = (a < b) ? a : b;
        min2 = (c < d) ? c : d;

        // Second Stage: Final Comparison
        min = (min1 < min2) ? min1 : min2;
    end

endmodule