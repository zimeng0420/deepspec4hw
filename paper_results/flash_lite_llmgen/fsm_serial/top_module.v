module top_module (
	input clk,
	input in,
	input reset,
	output done
);

	parameter IDLE = 0, START_DETECT = 1, RECEIVE_DATA = 2, STOP_DETECT = 3, ERROR_WAIT = 4;
	reg [2:0] state;
	reg [7:0] data_reg;
	reg [2:0] bit_count;
	reg in_reg;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			state <= IDLE;
			done <= 0;
			bit_count <= 0;
			data_reg <= 0;
		end else begin
			in_reg <= in;
			case (state)
				IDLE: begin
					done <= 0;
					if (in_reg == 0) begin
						state <= START_DETECT;
					end else begin
						state <= IDLE;
					end
				end
				START_DETECT: begin
					state <= RECEIVE_DATA;
				end
				RECEIVE_DATA: begin
					data_reg <= {in_reg, data_reg[7:1]};
					if (bit_count == 7) begin
						state <= STOP_DETECT;
						bit_count <= 0;
					end else begin
						bit_count <= bit_count + 1;
						state <= RECEIVE_DATA;
					end
				end
				STOP_DETECT: begin
					if (in_reg == 1) begin
						done <= 1;
						state <= IDLE;
					end else begin
						state <= ERROR_WAIT;
					end
				end
				ERROR_WAIT: begin
					if (in_reg == 1) begin
						state <= IDLE;
					end else begin
						state <= ERROR_WAIT;
					end
				end
				default: begin
					state <= IDLE;
					done <= 0;
					bit_count <= 0;
					data_reg <= 0;
				end
			endcase
		end
	end

endmodule