module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge);

    reg [7:0] prev_in;

    always @(posedge clk) begin
        anyedge <= (prev_in & ~in); // Detects falling edge for each bit
        prev_in <= in; // Store the current input as previous for the next cycle
    end

endmodule