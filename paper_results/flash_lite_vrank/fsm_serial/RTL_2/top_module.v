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

	reg [2:0] state;
	reg [7:0] data_reg;
	reg [2:0] bit_count;
	reg done_reg;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			data_reg <= 8'b0;
			bit_count <= 3'b0;
			done_reg <= 1'b0;
		end else begin
			done_reg <= 1'b0; // Reset done every cycle

			case (state)
				IDLE: begin
					if (!in) begin // Look for start bit (0)
						state <= START;
						bit_count <= 3'b0;
					end
				end
				START: begin
					// Wait a bit for the start bit to stabilize
					state <= DATA;
				end
				DATA: begin
					data_reg <= {in, data_reg[7:1]}; // Shift in new bit, LSB first
					bit_count <= bit_count + 1;
					if (bit_count == 3'd7) begin // Received all 8 data bits
						state <= STOP;
						bit_count <= 3'b0;
					end
				end
				STOP: begin
					if (in) begin // Check for stop bit (1)
						state <= IDLE;
						done_reg <= 1'b1;
					end else begin
						state <= ERROR; // Stop bit was incorrect
					end
				end
				ERROR: begin
					if (in) begin // Wait for the line to go high (stop bit)
						state <= IDLE; // Back to idle state
					end
				end
				default: begin
					state <= IDLE;
				end
			endcase
		end
	end

	assign done = done_reg;

endmodule