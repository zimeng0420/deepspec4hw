module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output reg f,
	output reg g
);

	// State encoding
	parameter STATE_A = 3'b000, STATE_B = 3'b001, STATE_C = 3'b010, 
		STATE_D = 3'b011, STATE_E = 3'b100, STATE_F = 3'b101;

	reg [2:0] state, next_state;

	// Sequential logic for state transitions
	always @(posedge clk) begin
		if (!resetn)
			state <= STATE_A;
		else
			state <= next_state;
	end

	// Logic for next state and outputs
	always @(*) begin
		// Default outputs
		f = 0;
		g = g;

		case (state)
			STATE_A: begin
				f = 1;
				next_state = STATE_B;
			end

			STATE_B: begin
				f = 0;
				if (x)
					next_state = STATE_C;
				else
					next_state = STATE_B;
			end

			STATE_C: begin
				if (!x)
					next_state = STATE_D;
				else
					next_state = STATE_C;
			end

			STATE_D: begin
				if (x)
					next_state = STATE_E;
				else
					next_state = STATE_B;
			end

			STATE_E: begin
				g = 1;
				if (y)
					next_state = STATE_F;
				else
					next_state = STATE_E;
			end

			STATE_F: begin
				g = g;
				next_state = STATE_F;
			end

			default: next_state = STATE_A;
		endcase
	end

endmodule