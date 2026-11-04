module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000; // Reset counter to 0
    end else if (q < 4'b1001) begin
        q <= q + 4'b0001; // Increment counter
    end else begin
        q <= 4'b0000; // Reset counter when reaching 10
    end
end

endmodule