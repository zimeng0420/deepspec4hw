module top_module(
	input clk,
	input reset,
	input [31:0] in,
	output reg [31:0] out
);

    reg [31:0] in_prev;  // Register to store the previous state of 'in'

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;  // Reset output when reset is high
            in_prev <= 32'b0;  // Clear previous input state
        end else begin
            // For each bit, detect the 1-to-0 transition and set the corresponding bit in 'out'
            out <= out | (in_prev & ~in); 
            
            // Update in_prev with the current input
            in_prev <= in;    
        end
    end

endmodule