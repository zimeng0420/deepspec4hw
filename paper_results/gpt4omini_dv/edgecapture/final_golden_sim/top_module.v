module top_module(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] last_in;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'b0;
        last_in <= 32'b0;
    end else begin
        last_in <= in;
        out <= out | (~in & last_in); // Set output to 1 if transition from 1 to 0 occurs
    end
end

endmodule