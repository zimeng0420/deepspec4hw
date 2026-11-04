module top_module (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'b100; // Reset to 4 when a is high
    end else begin
        q <= q + 1;  // Increment q when a is low
    end
end

endmodule