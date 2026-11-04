module top_module (
	input clk,
	input reset,
	input in,
	output disc,
	output flag,
	output err
);

	parameter S_IDLE = 3'b000;
	parameter S_1    = 3'b001;
	parameter S_11   = 3'b010;
	parameter S_111  = 3'b011;
	parameter S_1111 = 3'b100;
	parameter S_11111 = 3'b101;
	parameter S_111111 = 3'b110;
	parameter S_ERROR = 3'b111;

	reg [2:0] state, next_state;
	reg disc_r, flag_r, err_r;

	always @(posedge clk) begin
		if (reset) begin
			state <= S_IDLE;
			disc_r <= 1'b0;
			flag_r <= 1'b0;
			err_r <= 1'b0;
		end else begin
			state <= next_state;
			disc_r <= disc;
			flag_r <= flag;
			err_r <= err;
		end
	end

	always @(*) begin
		next_state = S_IDLE;
		disc = 1'b0;
		flag = 1'b0;
		err = 1'b0;

		case (state)
			S_IDLE: begin
				if (in)
					next_state = S_1;
			end
			S_1: begin
				if (in)
					next_state = S_11;
				else
					next_state = S_IDLE;
			end
			S_11: begin
				if (in)
					next_state = S_111;
				else
					next_state = S_IDLE;
			end
			S_111: begin
				if (in)
					next_state = S_1111;
				else
					next_state = S_IDLE;
			end
			S_1111: begin
				if (in)
					next_state = S_11111;
				else
					next_state = S_IDLE;
			end
			S_11111: begin
				if (in)
					next_state = S_111111;
				else begin
					next_state = S_IDLE;
					disc = 1'b1;
				end
			end
			S_111111: begin
				if (in) begin
					next_state = S_ERROR;
				end
				else begin
					next_state = S_IDLE;
					flag = 1'b1;
				end
			end
			S_ERROR: begin
				next_state = S_ERROR;
				err = 1'b1;
			end
			default:
				next_state = S_IDLE;
		endcase
	end
endmodule