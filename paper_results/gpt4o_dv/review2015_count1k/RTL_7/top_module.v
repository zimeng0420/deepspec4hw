module top_module(
    input clk,
    input reset,
    output reg [9:0] q);

    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;  // Reset to 0 on active-high reset
        else if (q == 10'd999)
            q <= 10'd0;  // Wrap around to 0 when reaching 999
        else
            q <= q + 10'd1;  // Increment the counter
    end
endmodule