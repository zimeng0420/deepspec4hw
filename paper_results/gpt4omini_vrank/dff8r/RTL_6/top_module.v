module top_module(
    input clk,
    input [7:0] d,
    input reset,
    output reg [7:0] q
);
    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b00000000; // Set output to zero on reset
        end else begin
            q <= d; // Transfer input to output on positive edge of clk
        end
    end
endmodule