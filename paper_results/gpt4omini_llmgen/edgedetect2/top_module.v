module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    
    reg [7:0] prev_in; // To hold the previous state of the input

    always @(posedge clk) begin
        // Detect 0 to 1 transitions
        anyedge <= (prev_in ^ in) & (in & ~prev_in);
        prev_in <= in; // Update previous input
    end
    
endmodule