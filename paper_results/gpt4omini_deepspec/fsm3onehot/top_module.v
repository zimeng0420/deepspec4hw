module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

always @(*) begin
	next_state = 4'b0000; // default state
	case (1'b1) // one-hot encoding
		state[0]: begin // State A
			if (in)
				next_state = 4'b0010; // Go to B
			else
				next_state = 4'b0001; // Stay in A
		end
		state[1]: begin // State B
			if (in)
				next_state = 4'b0010; // Stay in B
			else
				next_state = 4'b0100; // Go to C
		end
		state[2]: begin // State C
			if (in)
				next_state = 4'b1000; // Go to D
			else
				next_state = 4'b0001; // Go to A
		end
		state[3]: begin // State D
			if (in)
				next_state = 4'b0100; // Go to C
			else
				next_state = 4'b0010; // Go to B
		end
	endcase
end

assign out = state[3]; // Output is high only in State D

endmodule