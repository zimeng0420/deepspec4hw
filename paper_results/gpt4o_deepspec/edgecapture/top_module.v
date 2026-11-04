module top_module(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out);
    
    reg [31:0] in_prev; // Register to hold the previous state of the input

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;    // Reset output to 0
            in_prev <= 32'b0; // Reset previous input to 0
        end else begin
            out <= out | (in_prev & ~in);  // Update output based on transition detection
            in_prev <= in;                // Update the previous input with the current input
        end
    end

endmodule