module top_module (
	input clk,
	input in,
	input reset,
	output [7:0] out_byte,
	output done
);

	parameter IDLE = 0;
	parameter START = 1;
	parameter DATA = 2;
	parameter STOP = 3;
	parameter ERROR = 4;

	reg [2:0] state;
	reg [7:0] data_reg;
	reg done_reg;
	reg [2:0] bit_count;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			data_reg <= 8'b0;
			done_reg <= 1'b0;
			bit_count <= 3'b0;
		end else begin
			done_reg <= 1'b0;
			case (state)
				IDLE: begin
					if (!in) begin
						state <= START;
					end
				end
				START: begin
					state <= DATA;
					bit_count <= 3'b0;
				end
				DATA: begin
					data_reg[bit_count] <= in;
					bit_count <= bit_count + 1'b1;
					if (bit_count == 3'b111) begin
						state <= STOP;
					end
				end
				STOP: begin
					if (in) begin
						state <= IDLE;
						done_reg <= 1'b1;
					end else begin
						state <= ERROR;
					end
				end
				ERROR: begin
					if (in) begin
						state <= IDLE;
					end
				end
			endcase
		end
	end

	assign out_byte = data_reg;
	assign done = done_reg;

endmodule