module top_module (
	input clk,
	input in,
	input reset,
	output [7:0] out_byte,
	output done
);

	parameter IDLE = 0, START = 1, DATA = 2, STOP = 3;
	reg [1:0] state;
	reg [7:0] data_buffer;
	reg [2:0] bit_count;
	reg done_internal;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			data_buffer <= 8'b0;
			bit_count <= 3'b0;
			done_internal <= 1'b0;
		end else begin
			case (state)
				IDLE: begin
					done_internal <= 1'b0;
					if (!in) begin
						state <= START;
					end
				end
				START: begin
					state <= DATA;
					bit_count <= 3'b0;
				end
				DATA: begin
					data_buffer[bit_count] <= in;
					bit_count <= bit_count + 1'b1;
					if (bit_count == 3'b111) begin
						state <= STOP;
					end
				end
				STOP: begin
					if (in) begin
						state <= IDLE;
						done_internal <= 1'b1;
					end else begin
						state <= IDLE;  // Handle invalid stop bit - wait for a 1
						done_internal <= 1'b0;
					end
				end
			endcase
		end
	end

	assign out_byte = data_buffer;
	assign done = done_internal;

endmodule