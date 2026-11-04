module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (reset)
            q <= 4'b0001; // Reset to 1
        else if (q < 4'b1010) // Count from 1 to 10 (4'b0001 to 4'b1010)
            q <= q + 1;
        else
            q <= 4'b0001; // Reset to 1 after reaching 10
    end
endmodule