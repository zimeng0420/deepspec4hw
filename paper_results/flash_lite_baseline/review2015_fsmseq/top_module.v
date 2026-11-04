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
	reg [3:0] shift_reg;
	reg start_shifting_internal;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			shift_reg <= 4'b0;
			start_shifting_internal <= 1'b0;
		end else begin
			state <= next_state;
			if (start_shifting_internal) begin
				start_shifting_internal <= 1'b1; // Keep start_shifting high after it's set
			end
		end
	end

	always @(*) begin
		next_state = state;
		case (state)
			IDLE: begin
				if (data) begin
					next_state = S1;
					shift_reg = {data, shift_reg[3:1]};
				end else begin
					next_state = IDLE;
					shift_reg = {data, shift_reg[3:1]};
				end
			end
			S1: begin
				if (data) begin
					next_state = S2;
					shift_reg = {data, shift_reg[3:1]};
				end else begin
					next_state = IDLE;
					shift_reg = {data, shift_reg[3:1]};
				end
			end
			S2: begin
				if (data) begin
					next_state = S1;
					shift_reg = {data, shift_reg[3:1]};
				end else begin
					next_state = S3;
					shift_reg = {data, shift_reg[3:1]};
				end
			end
			S3: begin
				if (data) begin
					next_state = S4;
					shift_reg = {data, shift_reg[3:1]};
				end else begin
					next_state = IDLE;
					shift_reg = {data, shift_reg[3:1]};
				end
			end
			S4: begin
				next_state = S4; // Stay in S4 forever
				shift_reg = {data, shift_reg[3:1]};
				start_shifting_internal = 1'b1;
			end
			default: begin
				next_state = IDLE;
				shift_reg = 4'b0;
			end
		endcase
	end

	assign start_shifting = start_shifting_internal;

endmodule