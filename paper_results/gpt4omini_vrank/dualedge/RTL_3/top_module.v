module top_module(
    input clk,
    input d,
    output reg q
);

reg d_latch;

always @(posedge clk) begin
    d_latch <= d;
end

always @(negedge clk) begin
    q <= d_latch;
end

endmodule