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
        out <= out | ((in ^ {1'b0, in[31:1]}) & {32{1'b1}}) & ~in; // Capture the transition from 1 to 0
    end
end

endmodule