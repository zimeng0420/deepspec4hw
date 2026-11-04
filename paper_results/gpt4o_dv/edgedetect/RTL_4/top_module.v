module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        pedge <= in & ~prev_in;  // Detect positive edge for each bit
        prev_in <= in;           // Store current input as previous input for next cycle
    end

endmodule