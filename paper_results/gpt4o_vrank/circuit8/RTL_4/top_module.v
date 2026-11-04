module top_module (
	input clock,
	input a, 
	output reg p,
	output reg q
);

reg state;

always @(posedge clock) begin
    if (a) begin
        p <= 1;
        state <= 1;
    end else begin
        p <= 0;
        state <= 0;
    end
end

always @(negedge clock) begin
    if (state) begin
        q <= 1;
    end else begin
        q <= 0;
    end
end

endmodule