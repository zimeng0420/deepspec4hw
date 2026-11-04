module top_module(
    input clk,
    input d,
    output reg q
);

reg d_ff; // Intermediate register to hold the value of d

always @(posedge clk) begin
    d_ff <= d; // Capture d on the positive edge
end

always @(negedge clk) begin
    q <= d_ff; // Update q on the negative edge with the value captured on the positive edge
end

endmodule