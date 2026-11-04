module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);

	parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7, I = 8;
	reg [2:0] state, next_state;
	reg [1:0] x_history;
	reg f_reg, g_reg;

	// State register
	always @(posedge clk or negedge resetn) begin
		if (!resetn)
			state <= A;
		else
			state <= next_state;
	end

	// Output register
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			f_reg <= 0;
			g_reg <= 0;
		end else begin
			f_reg <= f;
			g_reg <= g;
		end
	end

	// Next state and output logic
	always @(*) begin
		next_state = state;
		f = 0;
		g = g_reg; // Maintain g value unless explicitly changed

		case (state)
			A: begin
				if (!resetn) begin
					next_state = A;
					f = 0;
					g = 0;
				end else begin
					next_state = B;
					f = 1;
					g = 0;
				end
			end
			B: begin
				next_state = C;
				f = 0;
				g = 0;
			end
			C: begin
				x_history = {x_history[0], x};
				if (x_history == 2'b10) begin // x = 1, 0, 1
					next_state = D;
					f = 0;
					g = 1;
				end else begin
					next_state = C;
					f = 0;
					g = 0;
				end
			end
			D: begin
				if (y) begin
					next_state = G;
					f = 0;
					g = 1;
				end else begin
					next_state = E;
					f = 0;
					g = 1;
				end
			end
			E: begin
				if (y) begin
					next_state = G;
					f = 0;
					g = 1;
				end else begin
					next_state = F;
					f = 0;
					g = 0;
				end
			end
			F: begin
				next_state = F;
				f = 0;
				g = 0;
			end
			G: begin
				next_state = G;
				f = 0;
				g = 1;
			end
			default: begin
				next_state = A;
				f = 0;
				g = 0;
			end
		endcase
	end

endmodule