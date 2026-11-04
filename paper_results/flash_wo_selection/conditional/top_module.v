module top_module (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

    always @(*) begin
        min = ((a < b) ? a : b) < ((c < d) ? c : d) ? ((a < b) ? a : b) : ((c < d) ? c : d);
    end

endmodule