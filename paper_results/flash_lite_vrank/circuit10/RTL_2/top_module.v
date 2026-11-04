module top_module (
	input clk,
	input a,
	input b,
	output q,
	output state
);

	reg q;

	always @(posedge clk) begin
		if (a & b) begin
			q <= 0;
		end else if (~a & b) begin
            q <= 0;
        end else if (a & ~b) begin
            q <= ~q;
        end
	end

	assign state = q;

endmodule