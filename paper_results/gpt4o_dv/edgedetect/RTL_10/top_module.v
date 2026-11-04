module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Detect positive edge
        pedge <= in & ~prev_in;
        // Update previous input state
        prev_in <= in;
    end

endmodule