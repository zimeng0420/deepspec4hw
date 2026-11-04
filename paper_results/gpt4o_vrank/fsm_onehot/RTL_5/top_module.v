module top_module (
	input in,
	input [9:0] state,
	output reg [9:0] next_state,
	output reg out1,
	output reg out2
);
	always @(*) begin
		out1 = 0; // Default output values
		out2 = 0;

		case (1'b1) // One-hot encoding check
			state[0]: next_state = in ? 10'b0000000010 : 10'b0000000001;
			state[1]: next_state = in ? 10'b0000000100 : 10'b0000000001;
			state[2]: next_state = in ? 10'b0000001000 : 10'b0000000001;
			state[3]: next_state = in ? 10'b0000010000 : 10'b0000000001;
			state[4]: next_state = in ? 10'b0000100000 : 10'b0000000001;
			state[5]: next_state = in ? 10'b0001000000 : 10'b0000001000;
			state[6]: next_state = in ? 10'b0010000000 : 10'b0000100000;
			state[7]: begin
				out2 = 1;
				next_state = in ? 10'b0100000000 : 10'b0000000001;
			end
			state[8]: begin
				out1 = 1;
				next_state = in ? 10'b0000000010 : 10'b0000000001;
			end
			state[9]: begin
				out1 = 1;
				out2 = 1;
				next_state = in ? 10'b0000000010 : 10'b0000000001;
			end
			default: next_state = 10'b0000000001; // Default to state S0
		endcase
	end
endmodule