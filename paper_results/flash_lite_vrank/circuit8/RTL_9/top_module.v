module top_module (
	input clock,
	input a, 
	output reg p,
	output reg q
);

	reg state;

	always @(posedge clock) begin
		if (a == 0) begin
			state <= 0;
		end else begin
			state <= 1;
		end
	end

	always @(*) begin
		case (state)
			0: begin
				p = 0;
				q = 0;
			end
			1: begin
				if (a == 1) begin
					p = 1;
					q = 0;
				end else begin
					p = 0;
					q = 1;
				end

			end
		endcase
	end

endmodule