module top_module(
    input clk,
    input d,
    output reg q
);

reg d_rise;
reg d_fall;

always @(posedge clk) begin
    d_rise <= d;
end

always @(negedge clk) begin
    d_fall <= d;
end

always @(*) begin
    q = (clk) ? d_rise : d_fall;
end

endmodule