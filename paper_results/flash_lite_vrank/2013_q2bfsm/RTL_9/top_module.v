module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output f,
	output g
);

	parameter A = 0, B = 1, C = 2, D = 3, E = 4, F = 5, G = 6, H = 7;
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

	// Output register for f
	always @(posedge clk or negedge resetn) begin
		if (!resetn)
			f_reg <= 0;
		else
			f_reg <= (state == B) ? 1 : 0;
	end

	// Output register for g
	always @(posedge clk or negedge resetn) begin
		if (!resetn)
			g_reg <= 0;
		else
			g_reg <= g_reg; // Maintain g value
	end

	// x history
	always @(posedge clk) begin
		x_history <= {x_history[0], x};
	end

	// Next state logic
	always @(*) begin
		next_state = state;
		case (state)
			A: begin
				if (!resetn)
					next_state = A; // Stay in A while reset is asserted
				else
					next_state = B;
			end
			B: begin
				next_state = C;
			end
			C: begin
				if (x_history == 2'b10 && x == 1) // x = 1, 0, 1
					next_state = D;
				else
					next_state = C;
			end
			D: begin
				next_state = E;
			end
			E: begin
                if (y == 1)
                    next_state = G;
                else
                    next_state = F;
			end
			F: begin
                next_state = F;
            end
            G: begin
                next_state = G;
            end
			default: next_state = A;
		endcase
	end

	// Output assignments
	assign f = f_reg;
	assign g = (state >= D) ? g_reg : 0;

    always @(posedge clk) begin
        if(state == D)
            g_reg <= 1;
        else if (state == E && y == 1)
            g_reg <= 1;
        else if (state == E && y == 0)
            g_reg <= 0;
        else if (!resetn)
            g_reg <= 0;

    end

endmodule