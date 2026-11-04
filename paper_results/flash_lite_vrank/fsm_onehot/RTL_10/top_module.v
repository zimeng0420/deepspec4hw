module top_module (
	input in,
	input [9:0] state,
	output [9:0] next_state,
	output out1,
	output out2);

	always @(*) begin
		case (1'b1)
			1'b1: begin
				// State S0
				if (state[0]) begin
					next_state[0] = ~in;
					next_state[1] = in;
					next_state[2] = 1'b0;
					next_state[3] = 1'b0;
					next_state[4] = 1'b0;
					next_state[5] = 1'b0;
					next_state[6] = 1'b0;
					next_state[7] = 1'b0;
					next_state[8] = 1'b0;
					next_state[9] = 1'b0;
				end

				// State S1
				if (state[1]) begin
					next_state[0] = ~in;
					next_state[2] = in;
					next_state[3] = 1'b0;
					next_state[4] = 1'b0;
					next_state[5] = 1'b0;
					next_state[6] = 1'b0;
					next_state[7] = 1'b0;
					next_state[8] = 1'b0;
					next_state[9] = 1'b0;
				end

				// State S2
				if (state[2]) begin
					next_state[0] = ~in;
					next_state[3] = in;
					next_state[4] = 1'b0;
					next_state[5] = 1'b0;
					next_state[6] = 1'b0;
					next_state[7] = 1'b0;
					next_state[8] = 1'b0;
					next_state[9] = 1'b0;
				end

				// State S3
				if (state[3]) begin
					next_state[0] = ~in;
					next_state[4] = in;
					next_state[5] = 1'b0;
					next_state[6] = 1'b0;
					next_state[7] = 1'b0;
					next_state[8] = 1'b0;
					next_state[9] = 1'b0;
				end

				// State S4
				if (state[4]) begin
					next_state[0] = ~in;
					next_state[5] = in;
					next_state[6] = 1'b0;
					next_state[7] = 1'b0;
					next_state[8] = 1'b0;
					next_state[9] = 1'b0;
				end

				// State S5
				if (state[5]) begin
					next_state[8] = ~in;
					next_state[6] = in;
					next_state[0] = 1'b0;
					next_state[7] = 1'b0;
					next_state[1] = 1'b0;
					next_state[2] = 1'b0;
					next_state[3] = 1'b0;
					next_state[4] = 1'b0;
					next_state[9] = 1'b0;
				end

				// State S6
				if (state[6]) begin
					next_state[9] = ~in;
					next_state[7] = in;
					next_state[0] = 1'b0;
					next_state[8] = 1'b0;
					next_state[1] = 1'b0;
					next_state[2] = 1'b0;
					next_state[3] = 1'b0;
					next_state[4] = 1'b0;
					next_state[5] = 1'b0;
				end

				// State S7
				if (state[7]) begin
					next_state[0] = ~in;
					next_state[7] = in;
					next_state[1] = 1'b0;
					next_state[2] = 1'b0;
					next_state[3] = 1'b0;
					next_state[4] = 1'b0;
					next_state[5] = 1'b0;
					next_state[6] = 1'b0;
					next_state[8] = 1'b0;
					next_state[9] = 1'b0;

				end

				// State S8
				if (state[8]) begin
					next_state[0] = ~in;
					next_state[1] = in;
					next_state[2] = 1'b0;
					next_state[3] = 1'b0;
					next_state[4] = 1'b0;
					next_state[5] = 1'b0;
					next_state[6] = 1'b0;
					next_state[7] = 1'b0;
					next_state[9] = 1'b0;
				end

				// State S9
				if (state[9]) begin
					next_state[0] = ~in;
					next_state[1] = in;
					next_state[2] = 1'b0;
					next_state[3] = 1'b0;
					next_state[4] = 1'b0;
					next_state[5] = 1'b0;
					next_state[6] = 1'b0;
					next_state[7] = 1'b0;
					next_state[8] = 1'b0;

				end
			end
		endcase
	end

	assign out1 = state[8] | state[9];
	assign out2 = state[7] | state[9];

endmodule