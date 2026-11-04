module top_module (
	input clk,
	input in,
	input reset,
	output done
);

	parameter IDLE = 0;
	parameter START = 1;
	parameter DATA = 2;
	parameter STOP = 3;
	parameter ERROR = 4;

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
			done_reg <= 0; // Clear done at the beginning of the clock cycle
		end
	end

	always @(*) begin
		next_state = state;
		done = done_reg; // Assign done based on the state and any error conditions

		case (state)
			IDLE: begin
				if (!in) begin // Start bit detected
					next_state = START;
				end else begin
					next_state = IDLE;
				end
			end
			START: begin
				next_state = DATA;
				bit_count = 0;
			end
			DATA: begin
				if (bit_count < 7) begin
					bit_count = bit_count + 1;
					next_state = DATA;
				end else begin
					next_state = STOP;
				end
			end
			STOP: begin
				if (in) begin
					// Stop bit correct
					done_reg = 1;
					next_state = IDLE;
				end else begin
					// Stop bit incorrect, go to ERROR state
					next_state = ERROR;
				end
			end
			ERROR: begin
				// Wait for stop bit
				if (in) begin
					next_state = IDLE;
				end else begin
					next_state = ERROR;
				end
			end
			default: begin
				next_state = IDLE;
			end
		endcase
	end

	always @(posedge clk) begin
		if (state == DATA) begin
			data_byte <= {in, data_byte[7:1]}; // Shift in the data bit
		end
	end

endmodule