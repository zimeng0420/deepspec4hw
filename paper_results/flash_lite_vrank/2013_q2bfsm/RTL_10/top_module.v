module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);

	// State Definitions
	parameter A = 3'b000;
	parameter B = 3'b001;
	parameter C = 3'b010;
	parameter D = 3'b011;
	parameter E = 3'b100;
	parameter F = 3'b101;
	parameter G = 3'b110;


	// State Variables
	reg [2:0] state, next_state;
	reg [1:0] x_history; // Holds the last two values of x
	reg f_reg, g_reg;
	reg y_detected;


	// State Transition Logic
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			state <= A;
			f_reg <= 0;
			g_reg <= 0;
			x_history <= 2'b00;
			y_detected <= 0;
		end else begin
			state <= next_state;
			f_reg <= f;
			g_reg <= g;
			if (state == D || state == F || state == G)
				y_detected <= y_detected; // Maintain y_detected state
			else
				y_detected <= 0;
		end
	end

	always @(*) begin
		next_state = state;
		f = 0;
		g = 0;

		case (state)
			A: begin
				if (!resetn) begin
					next_state = A;
					f = 0;
					g = 0;
				end
				else begin
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
				if (x_history == 2'b10)
				begin
					next_state = D;
					f = 0;
					g = 0;
				end
				else
				begin
					next_state = C;
					f = 0;
					g = 0;
				end
			end

			D: begin
				x_history = {x_history[0], x};
				if (x_history == 2'b01)
				begin
					next_state = E;
					f = 0;
					g = 1;
				end
				else
				begin
					next_state = D;
					f = 0;
					g = 0;
				end
			end

			E: begin
				if(y)
				begin
					next_state = G;
					f = 0;
					g = 1;
				end
				else
				begin
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