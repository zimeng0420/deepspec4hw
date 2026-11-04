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
	reg [2:0] next_state;
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
			state <= next_state;
			if (state == A) f <= 0; else f <= 0; // ensure f is 0 in A and the rest
		end
	end

	always @(*) begin
		next_state = state;
		f = 0;
		g = 0;
		y_detected = y_detected; // Maintain the state for y_detected

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
			end
			C: begin
				x_history = {x_history[0], x};
				if (x_history == 2'b10) begin
					next_state = D;
				end
			end
			D: begin
				if (x == 1) begin
					next_state = E;
				end else begin
					next_state = C; //Reset x check
				end
			end
			E: begin
				next_state = F;
			end
			F: begin
				g = 1;
				if (y == 1) begin
					next_state = G;
				end else if (y_detected == 1'b1) begin
					next_state = G;
				end
				else begin
					next_state = H;
				end
			end
			G: begin
				g = 1;
			end
			H: begin
				g = 0;
				y_detected = 0;
			end
		endcase
		if(state == F && y == 1) begin
				y_detected = 1;
		end
	end
endmodule