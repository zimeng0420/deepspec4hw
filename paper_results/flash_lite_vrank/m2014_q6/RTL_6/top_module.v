module top_module (
	input clk,
	input reset,
	input w,
	output z
);

	parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;
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
				next_state = w ? A : B;
				z_reg = 0;
			end
			B: begin
				next_state = w ? D : C;
				z_reg = 0;
			end
			C: begin
				next_state = w ? D : E;
				z_reg = 0;
			end
			D: begin
				next_state = w ? A : F;
				z_reg = 0;
			end
			E: begin
				next_state = w ? D : E;
				z_reg = 1;
			end
			F: begin
				next_state = w ? D : C;
				z_reg = 1;
			end
			default: begin
				next_state = A;
				z_reg = 0;
			end
		endcase
	end

	assign z = z_reg;

endmodule