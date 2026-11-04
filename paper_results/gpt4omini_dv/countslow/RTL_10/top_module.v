module top_module(
    input clk,
    input slowena,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 0; // Reset to 0
    end else if (slowena) begin
        if (q == 9) begin
            q <= 0; // Wrap around from 9 to 0
        end else begin
            q <= q + 1; // Increment the counter
        end
    end
end

endmodule