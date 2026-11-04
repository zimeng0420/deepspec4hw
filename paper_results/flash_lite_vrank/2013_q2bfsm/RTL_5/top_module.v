module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);

	parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7, I = 8;
	reg [3:0] state, next_state;
	reg [1:0] x_history;
	reg y_detected;

	always @(posedge clk or negedge resetn) begin
		if (!resetn)
			state <= A;
		else
			state <= next_state;
	end

	always @(*) begin
		next_state = state;
		f = 0;
		g = 0;
		y_detected = 0;

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
				if (x_history == 2'b10) begin
					next_state = D;
					f = 0;
					g = 0;
				end else begin
					next_state = C;
					f = 0;
					g = 0;
				end
			end
			D: begin
				x_history = {x_history[0], x};
				if (x_history == 2'b01) begin
					next_state = E;
					f = 0;
					g = 1;
				end else begin
					next_state = C;
					f = 0;
					g = 0;
				end
			end
			E: begin
				if (y) begin
					next_state = G;
					f = 0;
					g = 1;
					y_detected = 1;
				end else begin
					next_state = F;
					f = 0;
					g = 1;
				end
			end
			F: begin
				if (y) begin
					next_state = G;
					f = 0;
					g = 1;
					y_detected = 1;
				end else begin
					next_state = H;
					f = 0;
					g = 0;
				end
			end
			G: begin
				next_state = G;
				f = 0;
				g = 1;
			end
			H: begin
				next_state = H;
				f = 0;
				g = 0;
			end

			default: begin
				next_state = A;
				f = 0;
				g = 0;
			end
		endcase
	end
endmodule