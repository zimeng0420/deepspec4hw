module top_module(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out);

    reg [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;          // Clear the output on reset
            prev_in <= in;         // Initialize prev_in with the current in
        end else begin
            // Detect 1-to-0 transitions
            out <= out | (prev_in & ~in);
            // Update prev_in for the next cycle
            prev_in <= in;
        end
    end

endmodule