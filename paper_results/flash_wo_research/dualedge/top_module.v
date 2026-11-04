module top_module(
    input clk,
    input d,
    output reg q
);

reg clk_prev;

always @(posedge clk or negedge clk) begin
    if (clk == 1'b1 && clk_prev == 1'b0) begin // Rising edge
        q <= d;
    end else if (clk == 1'b0 && clk_prev == 1'b1) begin // Falling edge
        q <= d;
    end
end

always @(posedge clk) begin
    clk_prev <= clk;
end

endmodule