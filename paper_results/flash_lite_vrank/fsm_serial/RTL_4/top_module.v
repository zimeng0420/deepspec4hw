module top_module (
	input clk,
	input in,
	input reset,
	output done
);

	parameter IDLE = 3'b000;
	parameter START = 3'b001;
	parameter DATA = 3'b010;
	parameter STOP = 3'b011;
	parameter ERROR = 3'b100;

	reg [2:0] state;
	reg [2:0] next_state;
	reg [7:0] data_reg;
	reg [2:0] bit_count;
	reg done_r;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			done_r <= 1'b0;
			bit_count <= 3'b000;
		end else begin
			state <= next_state;
			done_r <= (next_state == IDLE && state == STOP);
		end
	end

	always @(*) begin
		next_state = state;
		case (state)
			IDLE: begin
				done_r = 1'b0;
				if (!in) begin // Start bit detected
					next_state = START;
					bit_count = 3'b000;
				end
			end
			START: begin
				if (in) begin // Should be 0
					next_state = ERROR;
				end else begin
					next_state = DATA;
				end
			end
			DATA: begin
				data_reg[bit_count] = in;
				if (bit_count == 7) begin
					next_state = STOP;
				end else begin
					next_state = DATA;
					bit_count = bit_count + 1'b1;
				end
			end
			STOP: begin
				if (in) begin // Stop bit expected
					next_state = IDLE;
				} else begin
					next_state = ERROR;
				end
			end
			ERROR: begin
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

	assign done = done_r;

endmodule