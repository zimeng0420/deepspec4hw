module top_module (
	input clk,
	input resetn,
	input x,
	input y,
	output reg f,
	output reg g
);

	// State encoding
	typedef enum reg [2:0] {
		STATE_A = 3'b000, // Reset State
		STATE_B = 3'b001, // Set f
		STATE_C = 3'b010, // Monitor x
		STATE_D = 3'b011, // Set g
		STATE_E = 3'b100, // Monitor y
		STATE_F = 3'b101  // g = 0
	} state_t;

	state_t current_state, next_state;
	integer x_count;

	// State transition
	always @(posedge clk or negedge resetn) begin
		if (!resetn) begin
			current_state <= STATE_A;
		end else begin
			current_state <= next_state;
		end
	end

	// Next state logic
	always @(*) begin
		next_state = current_state; // Default to hold current state
		f = 0; // Default output
		case (current_state)
			STATE_A: begin
				if (resetn) next_state = STATE_B;
			end

			STATE_B: begin
				f = 1; // Set f for one cycle
				next_state = STATE_C;
			end

			STATE_C: begin
				if (x_count == 3) begin
					next_state = STATE_D;
				end else begin
					if (x) x_count = x_count + 1; // Count sequence
					else x_count = 0;
				end
			end

			STATE_D: begin
				g = 1; // Set g for the next state
				next_state = STATE_E;
			end

			STATE_E: begin
				if (y) begin
					// Stay in STATE_E if y is 1
					next_state = STATE_E;
				end else if (x_count < 2) begin
					// Increment count for y being 0
					next_state = STATE_E;
					x_count = x_count + 1;
				end else begin
					next_state = STATE_F; // Move to STATE_F after two 0s
				end
			end

			STATE_F: begin
				g = 0; // Set g to 0 permanently
			end
		endcase
	end

endmodule