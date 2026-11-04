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
            out <= (out | (~in & {32{1'b1}})) | (out & in);
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end else begin
            out <= out | (in & ~out);
        end
    end

endmodule