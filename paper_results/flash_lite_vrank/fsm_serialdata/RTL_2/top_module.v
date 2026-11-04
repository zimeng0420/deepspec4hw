module top_module (
	input clk,
	input in,
	input reset,
	output [7:0] out_byte,
	output done
);

	parameter IDLE = 0, START = 1, DATA = 2, STOP = 3, ERROR = 4;
	reg [2:0] state, next_state;
	reg [7:0] data_reg;
	reg [2:0] bit_count;
	reg done_reg;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			done_reg <= 0;
			bit_count <= 0;
		end else begin
			state <= next_state;
			done_reg <= (next_state == STOP); // or ERROR

			if (next_state == DATA) begin
				bit_count <= bit_count + 1;
			end else if (next_state == START) begin
				bit_count <= 0;
			end
		end
	end

	always @(*) begin
		next_state = state;
		done = done_reg;
		out_byte = data_reg;


		case (state)
			IDLE: begin
				if (!in) begin  // Start bit detected (0)
					next_state = START;
				end else begin
					next_state = IDLE;
				end
				done = 0;
			end
			START: begin
				next_state = DATA;
				done = 0;
			end
			DATA: begin
				data_reg[bit_count] = in;
				if (bit_count == 7) begin
					next_state = STOP;
				end else begin
					next_state = DATA;
				end
				done = 0;
			end
			STOP: begin
				if (in) begin // Stop bit correct (1)
					next_state = IDLE;
					done = 1;
				end else begin
					next_state = ERROR;
					done = 0;

				end
			end
			ERROR: begin
				if (in) begin // Wait for the stop bit. Once the stop bit occurs go back to IDLE
					next_state = IDLE;
					done = 0;
				end else begin
					next_state = ERROR;
					done = 0;
				end
			end
			default: begin
				next_state = IDLE;
				done = 0;
			end
		endcase
	end
endmodule