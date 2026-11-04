module top_module (
	input clk,
	input reset,
	input in,
	output reg disc,
	output reg flag,
	output reg err
);

	// State Definition
	parameter S_IDLE = 0;
	parameter S_ONE = 1;
	parameter S_TWO = 2;
	parameter S_THREE = 3;
	parameter S_FOUR = 4;
	parameter S_FIVE = 5;
	parameter S_SIX = 6;
	parameter S_ERROR = 7;

	// State Register
	reg [2:0] state;

	// Next State Logic
	always @(posedge clk) begin
		if (reset) begin
			state <= S_IDLE;
			disc <= 0;
			flag <= 0;
			err <= 0;
		end else begin
			case (state)
				S_IDLE: begin
					disc <= 0;
					flag <= 0;
					err <= 0;
					if (in)
						state <= S_ONE;
					else
						state <= S_IDLE;
				end
				S_ONE: begin
					disc <= 0;
					flag <= 0;
					err <= 0;
					if (in)
						state <= S_TWO;
					else
						state <= S_IDLE;
				end
				S_TWO: begin
					disc <= 0;
					flag <= 0;
					err <= 0;
					if (in)
						state <= S_THREE;
					else
						state <= S_IDLE;
				end
				S_THREE: begin
					disc <= 0;
					flag <= 0;
					err <= 0;
					if (in)
						state <= S_FOUR;
					else
						state <= S_IDLE;
				end
				S_FOUR: begin
					disc <= 0;
					flag <= 0;
					err <= 0;
					if (in)
						state <= S_FIVE;
					else
						state <= S_IDLE;
				end
				S_FIVE: begin
					if (in) begin
						disc <= 0;
						flag <= 0;
						err <= 0;
						state <= S_SIX;
					end else begin
						disc <= 1;
						flag <= 0;
						err <= 0;
						state <= S_IDLE;
					end
				end
				S_SIX: begin
					if (in) begin
						disc <= 0;
						flag <= 0;
						err <= 0;
						state <= S_ERROR;
					end else begin
						disc <= 0;
						flag <= 1;
						err <= 0;
						state <= S_IDLE;
					end
				end
				S_ERROR: begin
					disc <= 0;
					flag <= 0;
					err <= 1;
					if (in)
						state <= S_ERROR;
					else
						state <= S_IDLE;
				end
				default: begin
					disc <= 0;
					flag <= 0;
					err <= 0;
					state <= S_IDLE;
				end
			endcase
		end
	end

endmodule