module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001; // reset to 1
    end else begin
        if (q < 4'b1010) begin
            q <= q + 1; // increment
        end else begin
            q <= 4'b0001; // wrap around to 1
        end
    end
end

endmodule