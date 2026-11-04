module top_module (
	input clk,
	input a,
	input b,
	output reg q,
	output reg state
);

always @(posedge clk) begin
    if (a & b) begin
        state <= state ^ 1;
        q <= ~q;
    end else if (a) begin
        state <= state;
        q <= ~q;
    end else if (b) begin
        state <= ~state;
        q <= q;
    end else begin
        state <= state;
        q <= q;
    end
end

endmodule