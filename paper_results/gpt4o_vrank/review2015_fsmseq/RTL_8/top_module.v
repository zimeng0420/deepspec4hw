module top_module(
	input clk,
	input reset,
	input data,
	output reg start_shifting
);

	reg [2:0] state, next_state;

	localparam S0 = 3'd0,
			   S1 = 3'd1,
			   S2 = 3'd2,
			   S3 = 3'd3,
			   S4 = 3'd4,
			   FOUND = 3'd5;

	// State transition logic
	always @(*) begin
		case (state)
			S0: next_state = data ? S1 : S0;
			S1: next_state = data ? S2 : S0;
			S2: next_state = data ? S2 : S3;
			S3: next_state = data ? S4 : S0;
			S4: next_state = data ? S2 : FOUND;
			FOUND: next_state = FOUND; // Remain in FOUND state
			default: next_state = S0;
		endcase
	end

	// State flip-flops with synchronous reset
	always @(posedge clk) begin
		if (reset) begin
			state <= S0;
			start_shifting <= 0;
		end else begin
			state <= next_state;
			if (state == FOUND)
				start_shifting <= 1;
		end
	end

endmodule