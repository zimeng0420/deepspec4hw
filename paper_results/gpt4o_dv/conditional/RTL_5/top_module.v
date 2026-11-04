module top_module (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

    // Combinational logic to find the minimum of four numbers
    always @(*) begin
        // Pairwise comparison
        reg [7:0] min1;
        reg [7:0] min2;
        
        // First stage: compare a and b, c and d
        min1 = (a < b) ? a : b;
        min2 = (c < d) ? c : d;
        
        // Second stage: compare the results of the first stage
        min = (min1 < min2) ? min1 : min2;
    end

endmodule