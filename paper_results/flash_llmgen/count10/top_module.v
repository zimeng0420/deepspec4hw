module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);

always_ff @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000; // Reset to 0
    end else begin
        if (q == 4'b1001) begin // Check for 9
            q <= 4'b0000; // Wrap around to 0
        end else begin
            q <= q + 1'b1; // Increment
        end
    end
end

endmodule