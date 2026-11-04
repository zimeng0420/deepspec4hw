module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    
    reg [7:0] prev_in;
    
    always @(posedge clk) begin
        // Detect 0 to 1 transitions and set anyedge
        anyedge <= (prev_in & ~in);
        
        // Store the current input state for the next rising edge
        prev_in <= in;
    end

endmodule