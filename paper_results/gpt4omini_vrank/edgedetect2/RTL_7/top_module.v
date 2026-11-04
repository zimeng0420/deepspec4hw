module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    anyedge <= (prev_in & ~in); // Detect rising edge
    prev_in <= in;              // Store the current input for the next cycle
end

endmodule