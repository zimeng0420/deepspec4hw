module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);

	parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7;
	reg [2:0] state;
	reg [1:0] x_history;
	reg f_reg;
	reg g_reg;

	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			state <= A;
			x_history <= 2'b00;
			f_reg <= 0;
			g_reg <= 0;
		end else begin
			case (state)
				A: begin
					f_reg <= 0;
					g_reg <= 0;
					if (!resetn) begin
						state <= A;
					end else begin
						state <= B;
					end
				end
				B: begin
					f_reg <= 1;
					g_reg <= 0;
					state <= C;
				end
				C: begin
					f_reg <= 0;
					g_reg <= 0;
					x_history <= {x_history[0], x};
					if (x_history == 2'b10) begin
						state <= D;
					end else begin
						state <= C;
					end
				end
				D: begin
					f_reg <= 0;
					g_reg <= 0;
					x_history <= {x_history[0], x};
					if (x_history == 2'b01) begin
						state <= E;
					end else begin
						state <= C;
					end
				end
				E: begin
					f_reg <= 0;
					g_reg <= 1;
					state <= F;
				end
				F: begin
					f_reg <= 0;
					if (y) begin
						state <= G;
					end else begin
						state <= F;
					end
				end
				G: begin
					f_reg <= 0;
					g_reg <= 1;
					state <= G;
				end
			endcase
		end
	end

	always @(posedge clk) begin
		if (!resetn) begin
			g_reg <= 0;
		end else begin
			case (state)
				F: begin
					if (y) begin
						state <= G;
					end
				end
				H: begin
					g_reg <= 0;
				end
			endcase
		end
	end

	assign f = f_reg;
	assign g = g_reg;
endmodule