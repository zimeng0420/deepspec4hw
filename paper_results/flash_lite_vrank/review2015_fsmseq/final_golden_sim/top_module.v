module top_module(
	input clk,
	input reset,
	input data,
	output start_shifting
);

	parameter IDLE = 0;
	parameter S1 = 1;
	parameter S2 = 2;
	parameter S3 = 3;
	parameter S4 = 4;

	reg [2:0] state, next_state;
	reg start_shifting_reg;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			start_shifting_reg <= 0;
		end else begin
			state <= next_state;
			if (state == S4) begin
				start_shifting_reg <= 1;
			end
		end
	end

	always @(*) begin
		next_state = state;
		case (state)
			IDLE: begin
				if (data)
					next_state = S1;
				else
					next_state = IDLE;
			end
			S1: begin
				if (data)
					next_state = S2;
				else
					next_state = IDLE;
			end
			S2: begin
				if (!data)
					next_state = S3;
				else
					next_state = S2;
			end
			S3: begin
				if (data)
					next_state = S4;
				else
					next_state = IDLE;
			end
			S4: begin
				next_state = S4; // Stay in S4 forever
			end
			default: begin
				next_state = IDLE;
			end
		endcase
	end

	assign start_shifting = start_shifting_reg;

endmodule