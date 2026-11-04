module top_module (
	input clock,
	input a, 
	output reg p,
	output reg q
);

	reg state;

	always @(posedge clock) begin
		if (a) begin
			state <= 1;
		end else begin
			state <= 0;
		end
	end

	always @(*) begin
		case (state)
			0: begin
				p = 0;
				q = 0;
			end
			1: begin
				p = a;
				q = 1;
			end
		endcase
	end
endmodule