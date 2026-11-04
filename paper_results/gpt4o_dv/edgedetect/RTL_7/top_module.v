module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_in; // Register to hold the previous state of 'in'

    always @(posedge clk) begin
        // Detect 0-to-1 transition for each bit
        pedge <= in & ~prev_in;
        
        // Update previous input state
        prev_in <= in;
    end

endmodule