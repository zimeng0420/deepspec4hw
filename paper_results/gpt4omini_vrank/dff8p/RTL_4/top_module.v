module top_module(
    input clk,
    input [7:0] d,
    input reset,
    output reg [7:0] q
);

    always @(negedge clk) begin
        if (reset) begin
            q <= 8'h34; // Set to 0x34 on reset
        end else begin
            q <= d; // Capture the data on negative edge of clk
        end
    end

endmodule