module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);
    always @(posedge clk) begin
        pedge <= (in & ~({8{1'b1}} << 1)) & (~in);
    end
endmodule