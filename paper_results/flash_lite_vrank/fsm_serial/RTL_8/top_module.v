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
	reg done_internal;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			data_reg <= 8'b0;
			bit_count <= 3'b0;
			done_internal <= 1'b0;
		end else begin
			done_internal <= 1'b0; // Default: no byte received this clock cycle.
			case (state)
				IDLE: begin
					if (~in) begin // Start bit detected
						state <= START;
						bit_count <= 3'b0;
					end
				end
				START: begin
					state <= DATA;
					// No specific action needed on start bit, just transition
				end
				DATA: begin
					data_reg <= {in, data_reg[7:1]}; // Shift in new bit
					bit_count <= bit_count + 1'b1;
					if (bit_count == 3'd7) begin
						state <= STOP;
					end
				end
				STOP: begin
					if (in) begin // Correct stop bit
						state <= IDLE;
						done_internal <= 1'b1;
					end else begin
						state <= ERROR; // Incorrect stop bit
					end
				end
				ERROR: begin
					if (in) begin // Wait for stop bit
						state <= IDLE;
					end else begin
						state <= ERROR; // Still waiting
					end
				end
				default: begin
					state <= IDLE;
					data_reg <= 8'b0;
					bit_count <= 3'b0;
					done_internal <= 1'b0;
				end
			endcase
		end
	end

	assign done = done_internal;

endmodule