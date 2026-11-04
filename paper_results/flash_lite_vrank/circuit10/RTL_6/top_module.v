module top_module (
	input clk,
	input a,
	input b,
	output q,
	output state
);

	reg q;
	assign state = q;

	always @(posedge clk) begin
		if (a & b) begin
			q <= 0;
		end else if (~a & b) begin
            q <= 0;
        end else if (a & ~b) begin
            q <= 0;
        end else if (~a & ~b) begin
            q <= q;
        end else if (q==1 && a==1 && b==1) begin
            q <= 0;
        end
	end
endmodule