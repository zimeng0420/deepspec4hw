module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        // Detect any edge (0 to 1 or 1 to 0) and set the corresponding bit in anyedge
        anyedge <= in ^ prev_in;
        // Store the current input as the previous input for the next cycle
        prev_in <= in;
    end
    
endmodule