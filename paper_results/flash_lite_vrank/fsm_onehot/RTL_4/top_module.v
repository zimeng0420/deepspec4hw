module top_module (
	input in,
	input [9:0] state,
	output [9:0] next_state,
	output out1,
	output out2);

	// State transition logic
	always @(*) begin
		case (1'b1)  // Use a constant for case selection
			state[0]: next_state = in ? 10'b0000000010 : 10'b0000000001; // S0
			state[1]: next_state = in ? 10'b0000000100 : 10'b0000000001; // S1
			state[2]: next_state = in ? 10'b0000001000 : 10'b0000000001; // S2
			state[3]: next_state = in ? 10'b0000010000 : 10'b0000000001; // S3
			state[4]: next_state = in ? 10'b0000100000 : 10'b0000000001; // S4
			state[5]: next_state = in ? 10'b0001000000 : 10'b0000000001; // S5
			state[6]: next_state = in ? 10'b0010000000 : 10'b0001000000; // S6
			state[7]: next_state = in ? 10'b0000000010 : 10'b0000000010; // S7
			state[8]: next_state = in ? 10'b0000000010 : 10'b00000000001; // S8
			state[9]: next_state = in ? 10'b0000000010 : 10'b00000000001; // S9
			default: next_state = 10'b0000000001;
		endcase
	end

	// Output logic
	assign out1 = state[8] || state[9];
	assign out2 = state[7] || state[9];

endmodule