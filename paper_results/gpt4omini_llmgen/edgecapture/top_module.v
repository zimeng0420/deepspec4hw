module top_module(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in; // To store the previous state of the input

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0; // Reset the output to 0
            prev_in <= 32'b0; // Reset the previous input state
        end else begin
            prev_in <= in; // Store the current input state
            
            // Capture condition: detect the falling edge of input bits
            out <= (prev_in & ~in) | out; // Set the output bit to 1 when the corresponding input bit goes from 1 to 0
        end
    end

endmodule