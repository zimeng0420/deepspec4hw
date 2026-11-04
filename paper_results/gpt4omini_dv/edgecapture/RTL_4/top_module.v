module top_module(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] previous_in;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'b0;
        previous_in <= 32'b0;
    end else begin
        // Capture transition from 1 to 0
        out <= out | ((previous_in & ~in) & 32'hFFFFFFFF);
        previous_in <= in;
    end
end

endmodule