module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] last_in;

    always @(posedge clk) begin
        anyedge <= (last_in & ~in);  // Detect the 0 to 1 transition
        last_in <= in;                // Update last_in to current input
    end
endmodule