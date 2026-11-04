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
        out <= out | ((~in & {32{1'b1}}) & (in ^ {32{1'b0}}));
        for (int i = 0; i < 32; i = i + 1) begin
            if (in[i] == 0 && out[i] == 0) begin
                out[i] <= 1;
            end
        end
    end
end

endmodule