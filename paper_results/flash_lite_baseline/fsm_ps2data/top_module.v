module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output [23:0] out_bytes,
	output done
);

	parameter IDLE = 2'b00;
	parameter SEARCH = 2'b01;
	parameter COLLECT = 2'b10;
	parameter DONE_STATE = 2'b11;

	reg [1:0] state, next_state;
	reg [7:0] byte1, byte2, byte3;
	reg [23:0] out_bytes_reg;
	reg done_reg, done_next;
	reg [1:0] byte_count;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			done_reg <= 1'b0;
			byte_count <= 2'b00;
		end else begin
			state <= next_state;
			done_reg <= done_next;
		end
	end

	always @(*) begin
		done_next = 1'b0;
		next_state = state;
		case (state)
			IDLE: begin
				if (reset) begin
					next_state = IDLE;
				end else begin
					next_state = SEARCH;
				end
			end
			SEARCH: begin
				if (reset) begin
					next_state = IDLE;
				end else begin
					if (in[3]) begin
						next_state = COLLECT;
						byte_count = 2'b01;
					end else begin
						next_state = SEARCH;
					end
				end
			end
			COLLECT: begin
				if (reset) begin
					next_state = IDLE;
				end else begin
					case (byte_count)
						2'b01: begin
							byte1 = in;
							byte_count = 2'b10;
							next_state = COLLECT;
						end
						2'b10: begin
							byte2 = in;
							byte_count = 2'b11;
							next_state = COLLECT;
						end
						2'b11: begin
							byte3 = in;
							byte_count = 2'b00;
							next_state = DONE_STATE;
						end
					endcase
				end
			end
			DONE_STATE: begin
				if (reset) begin
					next_state = IDLE;
				end else begin
					done_next = 1'b1;
					out_bytes_reg = {byte1, byte2, byte3};
					next_state = IDLE;
				end
			end
			default: begin
				next_state = IDLE;
			end
		endcase
	end

	assign done = done_reg;
	assign out_bytes = out_bytes_reg;

endmodule