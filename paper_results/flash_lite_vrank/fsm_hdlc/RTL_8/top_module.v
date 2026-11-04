module top_module (
	input clk,
	input reset,
	input in,
	output disc,
	output flag,
	output err
);

	parameter IDLE = 3'b000;
	parameter SEEN_1 = 3'b001;
	parameter SEEN_11 = 3'b010;
	parameter SEEN_111 = 3'b011;
	parameter SEEN_1111 = 3'b100;
	parameter SEEN_11111 = 3'b101;
	parameter SEEN_111111 = 3'b110;
	parameter ERROR = 3'b111;

	reg [2:0] state, next_state;
	reg disc_reg, flag_reg, err_reg;

	// State transition logic
	always @(posedge clk) begin
		if (reset)
			state <= IDLE;
		else
			state <= next_state;
	end

	// Output logic
	always @(posedge clk) begin
		if (reset) begin
			disc_reg <= 1'b0;
			flag_reg <= 1'b0;
			err_reg <= 1'b0;
		end
		else begin
			case (state)
				SEEN_11111: disc_reg <= 1'b1;
				SEEN_111111: flag_reg <= 1'b1;
				ERROR: err_reg <= 1'b1;
				default: begin
					disc_reg <= 1'b0;
					flag_reg <= 1'b0;
					err_reg <= 1'b0;
				end
			endcase
		end
	end


	// Next state logic
	always @(*) begin
		next_state = IDLE;
		case (state)
			IDLE: begin
				if (in)
					next_state = SEEN_1;
				else
					next_state = IDLE;
			end
			SEEN_1: begin
				if (in)
					next_state = SEEN_11;
				else
					next_state = IDLE;
			end
			SEEN_11: begin
				if (in)
					next_state = SEEN_111;
				else
					next_state = IDLE;
			end
			SEEN_111: begin
				if (in)
					next_state = SEEN_1111;
				else
					next_state = IDLE;
			end
			SEEN_1111: begin
				if (in)
					next_state = SEEN_11111;
				else
					next_state = IDLE;
			end
			SEEN_11111: begin
				if (in)
					next_state = SEEN_111111;
				else
					next_state = IDLE;
			end
			SEEN_111111: begin
				if (in)
					next_state = ERROR;
				else
					next_state = IDLE;
			end
			ERROR: begin
                if (in)
                    next_state = ERROR;
                else
                    next_state = IDLE;
            end
			default:
				next_state = IDLE;
		endcase
	end

	assign disc = disc_reg;
	assign flag = flag_reg;
	assign err = err_reg;

endmodule