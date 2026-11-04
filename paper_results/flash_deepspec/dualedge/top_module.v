module top_module(
    input clk,
    input d,
    output reg q
);

reg p;
reg n;

always @(posedge clk) begin
    p <= d ^ n;
end

always @(negedge clk) begin
    n <= d ^ p;
end

always @(*) begin
    q = p ^ n;
end

endmodule