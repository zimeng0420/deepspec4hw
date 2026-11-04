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
					next_state[0] = ~in; // S0 if in=0
					next_state[1] = in;   // S1 if in=1
				end
				// State S1
				else if (state[1]) begin
					next_state[0] = ~in; // S0 if in=0
					next_state[2] = in;   // S2 if in=1
				end
				// State S2
				else if (state[2]) begin
					next_state[0] = ~in; // S0 if in=0
					next_state[3] = in;   // S3 if in=1
				end
				// State S3
				else if (state[3]) begin
					next_state[0] = ~in; // S0 if in=0
					next_state[4] = in;   // S4 if in=1
				end
				// State S4
				else if (state[4]) begin
					next_state[0] = ~in; // S0 if in=0
					next_state[5] = in;   // S5 if in=1
				end
				// State S5
				else if (state[5]) begin
					next_state[8] = ~in; // S8 if in=0
					next_state[6] = in;   // S6 if in=1
				end
				// State S6
				else if (state[6]) begin
					next_state[9] = ~in; // S9 if in=0
					next_state[7] = in;   // S7 if in=1
				end
				// State S7
				else if (state[7]) begin
					next_state[0] = ~in; // S0 if in=0
					next_state[7] = in;   // S7 if in=1
				end
				// State S8
				else if (state[8]) begin
					next_state[0] = ~in; // S0 if in=0
					next_state[1] = in;   // S1 if in=1
				end
				// State S9
				else if (state[9]) begin
					next_state[0] = ~in; // S0 if in=0
					next_state[1] = in;   // S1 if in=1
				end
				else begin
					//default next state to S0, in case any state is not defined
					next_state[0] = 1'b1;
					next_state[1] = 1'b0;
					next_state[2] = 1'b0;
					next_state[3] = 1'b0;
					next_state[4] = 1'b0;
					next_state[5] = 1'b0;
					next_state[6] = 1'b0;
					next_state[7] = 1'b0;
					next_state[8] = 1'b0;
					next_state[9] = 1'b0;
				end
			end
		endcase
	end


	// Output Logic
	assign out1 = state[8] | state[9] ;
	assign out2 = state[7] | state[9] ;
endmodule