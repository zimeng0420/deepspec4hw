module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0001; // Reset to 1
        end else begin
            if (q < 4'b1010) begin
                q <= q + 1; // Increment until 10
            end else begin
                q <= 4'b0001; // Wrap around to 1 after 10
            end
        end
    end
endmodule