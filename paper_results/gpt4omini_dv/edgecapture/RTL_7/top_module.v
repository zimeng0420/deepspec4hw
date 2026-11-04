module top_module(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'b0; 
    end else begin
        out <= out | ((prev_in == 32'hFFFFFFFF) & (~in & prev_in)); // Capture transitions from 1 to 0
        prev_in <= in; // Store current input for next comparison
    end
end

endmodule