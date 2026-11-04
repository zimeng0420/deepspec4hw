module top_module(
    input clk,
    input reset,
    output reg [9:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0; // Reset the counter to 0
        end
        else if (q == 10'd999) begin
            q <= 10'd0; // Wrap around to 0 when 999 is reached
        end
        else begin
            q <= q + 10'd1; // Increment the counter
        end
    end

endmodule