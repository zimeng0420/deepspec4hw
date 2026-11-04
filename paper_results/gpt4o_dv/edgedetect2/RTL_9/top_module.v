module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    
    reg [7:0] prev_in;
    
    always @(posedge clk) begin
        anyedge <= (~prev_in & in); // outputs 1 if there's a 0-to-1 transition
        prev_in <= in; // store the current input to prev_in for next cycle comparison
    end

endmodule