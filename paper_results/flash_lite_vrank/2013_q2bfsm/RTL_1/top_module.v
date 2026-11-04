module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);

	parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7, I = 8;

	reg [2:0] state;
	reg [1:0] x_history;
	reg y_detected;

	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			state <= A;
			f <= 0;
			g <= 0;
			x_history <= 2'b00;
			y_detected <= 0;
		end else begin
			case (state)
				A: begin
					f <= 0;
					g <= 0;
					if (state != A) begin
						x_history <= 2'b00;
						y_detected <= 0;
					end
					state <= (state == A) ? B : A;
				end
				B: begin
					f <= 1;
					g <= 0;
					state <= C;
				end
				C: begin
					f <= 0;
					g <= 0;
					x_history <= {x_history[0], x};
					if (x_history == 2'b10) begin
						state <= D;
					end else begin
						state <= C;
					end
				end
				D: begin
					f <= 0;
					g <= 0;
					if (x == 1) begin
						state <= E;
					end else begin
						x_history <= {x_history[0], x};
						state <= C;
					end
				end
				E: begin
					f <= 0;
					g <= 1;
					y_detected <= 0;
					state <= F;
				end
				F: begin
					f <= 0;
					g <= 1;
					if (y == 1) begin
						y_detected <= 1;
						state <= G;
					end else begin
						state <= H;
					end
				end
				H: begin
					f <= 0;
					g <= 1;
					if (y == 1) begin
						y_detected <= 1;
						state <= G;
					end else begin
						state <= I;
					end
				end
				G: begin
					f <= 0;
					g <= 1;
					state <= G;
				end
				I: begin
					f <= 0;
					g <= 0;
					state <= I;
				end
				default: begin
					state <= A;
					f <= 0;
					g <= 0;
					x_history <= 2'b00;
					y_detected <= 0;
				end
			endcase
		end
	end
endmodule