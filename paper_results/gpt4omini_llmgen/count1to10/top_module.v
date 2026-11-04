module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001; // Reset to 1
    end else begin
        if (q == 4'b1010) begin
            q <= 4'b0001; // Roll over back to 1 when reaching 10
        end else begin
            q <= q + 1; // Increment the counter
        end
    end
end

initial begin
    q = 4'b0001; // Initialize counter to 1
end

endmodule