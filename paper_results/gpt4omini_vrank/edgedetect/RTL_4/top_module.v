module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge);
    
    always @(posedge clk) begin
        pedge <= (in & ~{in[7:0]}) | (pedge & ~in);
    end
    
endmodule