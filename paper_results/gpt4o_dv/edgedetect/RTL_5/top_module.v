module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge);

    reg [7:0] prev_in;  // Register to hold previous value of input
    
    always @(posedge clk) begin
        pedge <= in & ~prev_in;  // Detect positive edge by comparing current and previous input values
        prev_in <= in;  // Update previous input value
    end

endmodule