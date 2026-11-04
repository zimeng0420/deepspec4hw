module top_module (
	input clk,
	input in,
	input reset,
	output done
);

	parameter IDLE = 0,
			START = 1,
			DATA = 2,
			STOP = 3,
			ERROR = 4;

	reg [2:0] state, next_state;
	reg [2:0] bit_count;
	reg [7:0] data_byte;
	reg done_reg;


	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			bit_count <= 0;
			data_byte <= 0;
			done_reg <= 0;
		end else begin
			state <= next_state;
			done_reg <= (state == STOP) && (next_state == IDLE);
		end
	end

	always @(*) begin
		next_state = state;
		done = done_reg;

		case (state)
			IDLE: begin
				if (!in) begin
					next_state = START;
					bit_count = 0;
				end
			end
			START: begin
				next_state = DATA;
			end
			DATA: begin
				data_byte[bit_count] = in;
				if (bit_count == 7) begin
					next_state = STOP;
				end else begin
					next_state = DATA;
					bit_count = bit_count + 1;
				end
			end
			STOP: begin
				if (in) begin
					next_state = IDLE;
					bit_count = 0;
				end else begin
					next_state = ERROR;
				end
			end
			ERROR: begin
				if (in) begin
					next_state = IDLE;
					bit_count = 0;
				end else begin
					next_state = ERROR;
				end
			end
			default: begin
				next_state = IDLE;
				bit_count = 0;
			end
		endcase
	end

endmodule