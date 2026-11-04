module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);

	parameter A = 3'b000;
	parameter B = 3'b001;
	parameter C = 3'b010;
	parameter D = 3'b011;
	parameter E = 3'b100;
	parameter F = 3'b101;
	parameter G = 3'b110;
	parameter H = 3'b111;


	reg [2:0] state;
	reg [2:0] next_state;
	reg [2:0] x_history;
	reg f_reg;
	reg g_reg;
	reg y_count;

	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			state <= A;
			f_reg <= 0;
			g_reg <= 0;
			x_history <= 3'b000;
			y_count <= 0;
		end else begin
			state <= next_state;
			f_reg <= f;
			g_reg <= g;
			x_history <= {x_history[1:0], x};
		end
	end

	always @(*) begin
		next_state = state;
		f = 0;
		g = g_reg;
		y_count = y_count;


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
					x_history = 3'b000;
				end
			end

			B: begin
				next_state = C;
				f = 0;
				g = 0;
			end

			C: begin
				if (x_history == 3'b101) begin
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
					next_state = H;
					f = 0;
					g = 1;
				end else begin
					next_state = E;
					f = 0;
					g = 1;
					y_count = 1;
				end
			end

			E: begin
				if (y) begin
					next_state = H;
					f = 0;
					g = 1;
				end else if (y_count == 1) begin
					next_state = F;
					f = 0;
					g = 0;
				end else begin
					next_state = E;
					f = 0;
					g = 1;
					y_count = 1;
				end
			end

			F: begin
				next_state = F;
				f = 0;
				g = 0;
			end

			H: begin
				next_state = H;
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