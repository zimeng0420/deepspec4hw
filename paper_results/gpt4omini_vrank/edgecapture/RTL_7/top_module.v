module top_module(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);
    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end else begin
            out <= (in == 32'b0) ? out : (out | (~in & (in ^ {in[30:0], 1'b0})));
        end
    end
endmodule