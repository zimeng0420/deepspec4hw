module top_module (
	input clk,
	input reset,
	input in,
	output disc,
	output flag,
	output err
);

	parameter IDLE = 0,
		S1 = 1,
		S11 = 2,
		S111 = 3,
		S1111 = 4,
		S11111 = 5,
		S111110 = 6,
		S111111 = 7,
		ERROR = 8;

	reg [3:0] state, next_state;
	reg disc_reg, flag_reg, err_reg;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			disc_reg <= 1'b0;
			flag_reg <= 1'b0;
			err_reg <= 1'b0;
		end else begin
			state <= next_state;
			disc_reg <= 1'b0;
			flag_reg <= 1'b0;
			err_reg <= 1'b0;
		end
	end

	always @(*) begin
		next_state = IDLE;
		disc = 1'b0;
		flag = 1'b0;
		err = 1'b0;

		case (state)
			IDLE: begin
				if (in)
					next_state = S1;
				else
					next_state = IDLE;
			end
			S1: begin
				if (in)
					next_state = S11;
				else
					next_state = IDLE;
			end
			S11: begin
				if (in)
					next_state = S111;
				else
					next_state = IDLE;
			end
			S111: begin
				if (in)
					next_state = S1111;
				else
					next_state = IDLE;
			end
			S1111: begin
				if (in)
					next_state = S11111;
				else
					next_state = IDLE;
			end
			S11111: begin
				if (in)
					next_state = S111111;
				else begin
					next_state = S111110;
					disc = 1'b1;
					disc_reg = 1'b1;
				end
			end
			S111110: begin
				next_state = IDLE;
			end
			S111111: begin
				if (in) begin
					next_state = ERROR;
				end else begin
					next_state = IDLE;
					flag = 1'b1;
					flag_reg = 1'b1;
				end
			end
			ERROR: begin
				next_state = ERROR;
				err = 1'b1;
				err_reg = 1'b1;
			end
			default:
				next_state = IDLE;
		endcase
	end

	// Output registers to hold the output values for one clock cycle
	always @(posedge clk) begin
		if (reset) begin
			disc <= 1'b0;
			flag <= 1'b0;
			err <= 1'b0;
		end else begin
			disc <= disc_reg;
			flag <= flag_reg;
			err <= err_reg;
		end
	end

endmodule