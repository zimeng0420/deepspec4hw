module top_module(
    input clk,
    input reset,
    output reg [9:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 0; // Reset to 0
    end else if (q == 999) begin
        q <= 0; // Wrap around to 0
    end else begin
        q <= q + 1; // Increment counter
    end
end

endmodule