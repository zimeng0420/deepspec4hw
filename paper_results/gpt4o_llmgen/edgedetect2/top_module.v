module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev; // Previous state register

    always @(posedge clk) begin
        // Detect rising edges for each bit
        anyedge <= (~prev & in); // Set anyedge[i] if prev[i] was 0 and in[i] is 1
        prev <= in;              // Update prev with current input
    end
    
endmodule