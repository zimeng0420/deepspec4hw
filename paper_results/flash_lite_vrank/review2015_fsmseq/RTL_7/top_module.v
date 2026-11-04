module top_module(
	input clk,
	input reset,
	input data,
	output start_shifting
);

	parameter IDLE = 0;
	parameter S1 = 1;
	parameter S11 = 2;
	parameter S110 = 3;
	parameter S1101 = 4;

	reg [2:0] state, next_state;

	always @(posedge clk) begin
		if (reset)
			state <= IDLE;
		else
			state <= next_state;
	end

	always @(*) begin
		next_state = state;
		start_shifting = 0;

		case (state)
			IDLE: begin
				if (data)
					next_state = S1;
				else
					next_state = IDLE;
			end
			S1: begin
				if (data)
					next_state = S11;
				else
					next_state = IDLE;
			end
			S11: begin
				if (data)
					next_state = S11;
				else
					next_state = S110;
			end
			S110: begin
				if (data)
					next_state = S1;
				else
					next_state = S1101;
			end
			S1101: begin
				start_shifting = 1;
				next_state = S1101;
			end
			default:
				next_state = IDLE;
		endcase
	end

endmodule