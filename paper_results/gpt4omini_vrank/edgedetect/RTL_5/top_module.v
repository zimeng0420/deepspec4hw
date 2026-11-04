module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);
    reg [7:0] in_d;

    always @(posedge clk) begin
        pedge <= in_d & ~in; // Set output only if previous was 0 and current is 1
        in_d <= in; // Store the current input for the next cycle
    end
endmodule