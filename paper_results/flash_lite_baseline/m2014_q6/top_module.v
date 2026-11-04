module top_module (
	input clk,
	input reset,
	input w,
	output z
);

	parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;
	reg [2:0] state, next_state;
	reg z_reg;

	always @(posedge clk) begin
		if (reset)
			state <= A;
		else
			state <= next_state;
	end

	always @(*) begin
		case (state)
			A: begin
				z_reg = 0;
				if (w)
					next_state = A;
				else
					next_state = B;
			end
			B: begin
				z_reg = 0;
				if (w)
					next_state = D;
				else
					next_state = C;
			end
			C: begin
				z_reg = 0;
				if (w)
					next_state = D;
				else
					next_state = E;
			end
			D: begin
				z_reg = 0;
				if (w)
					next_state = A;
				else
					next_state = F;
			end
			E: begin
				z_reg = 1;
				if (w)
					next_state = D;
				else
					next_state = E;
			end
			F: begin
				z_reg = 1;
				if (w)
					next_state = D;
				else
					next_state = C;
			end
			default: begin
				z_reg = 0;
				next_state = A;
			end
		endcase
	end

	assign z = z_reg;

endmodule