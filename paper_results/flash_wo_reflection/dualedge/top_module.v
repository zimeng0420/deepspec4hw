module top_module(
    input clk,
    input d,
    output reg q
);

reg p, n;

always @(posedge clk)
    p <= d ^ n;

always @(negedge clk)
    n <= d ^ p;

always @(p or n)
    q <= p ^ n;

endmodule