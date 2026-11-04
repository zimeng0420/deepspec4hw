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

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			shift_reg <= 4'b0;
			start_shifting <= 0;
		end else begin
			state <= next_state;
		end
	end

	always @(*) begin
		case (state)
			IDLE: begin
				if (data)
					next_state = S1;
				else
					next_state = IDLE;
			end
			S1: begin
				if (data)
					next_state = S1;
				else
					next_state = S2;
			end
			S2: begin
				if (data)
					next_state = S3;
				else
					next_state = IDLE;
			end
			S3: begin
				if (data)
					next_state = S1;
				else
					next_state = S4;
			end
			S4: begin
				next_state = S4;
			end
			default:
				next_state = IDLE;
		endcase
	end

	always @(posedge clk) begin
		if(reset) begin
			start_shifting <= 0;
		end else begin
			if (state == S4) begin
				start_shifting <= 1;
			end
		end
	end

endmodule