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
	reg valid_stop_bit;
	reg prev_in;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			data_reg <= 8'b0;
			bit_count <= 3'b0;
			done <= 1'b0;
			valid_stop_bit <= 1'b0;
			prev_in <= 1'b1; // Initialize prev_in to idle state
		end else begin
			case (state)
				IDLE: begin
					done <= 1'b0;
					if (!in && prev_in) begin // Detect start bit (transition from 1 to 0)
						state <= START;
						bit_count <= 3'b0;
						prev_in <= in;
					end else begin
						prev_in <= in;
					end
				end
				START: begin
					if (in == 1'b0) begin
						state <= DATA;
						prev_in <= in;
					end
					else begin
						state <= IDLE;
						prev_in <= in;
					end
				end
				DATA: begin
					data_reg[bit_count] <= in;
					bit_count <= bit_count + 1'b1;
					prev_in <= in;
					if (bit_count == 3'd7) begin
						state <= STOP;
					end
				end
				STOP: begin
					if (in == 1'b1) begin
						done <= 1'b1;
						state <= IDLE;
						prev_in <= in;
					end else begin
						state <= ERROR;
						prev_in <= in;
					end
				end
				ERROR: begin
					done <= 1'b0;
					if (in == 1'b1) begin
						state <= IDLE;
						prev_in <= in;
					end else begin
						prev_in <= in;
					end
				end
			endcase
		end
	end

endmodule