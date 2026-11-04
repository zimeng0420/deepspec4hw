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
    parameter WAIT_STOP = 3'b101;

	reg [2:0] state, next_state;
	reg [7:0] data_reg;
	reg [2:0] bit_count;
	reg done_reg;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			done_reg <= 1'b0;
			bit_count <= 3'b000;
		end else begin
			state <= next_state;
			done_reg <= (state == STOP) && (next_state == IDLE);
		end
	end

	always @(*) begin
		next_state = state;
		case (state)
			IDLE: begin
				done_reg = 1'b0;
				if (!in) begin // Start bit detected
					next_state = START;
				end else begin
					next_state = IDLE;
				end
			end
			START: begin
				// Wait for a full bit period, then move to data
				next_state = DATA;
				bit_count = 3'b000; // Reset bit counter
			end
			DATA: begin
				data_reg[bit_count] = in;
				if (bit_count == 7) begin // All 8 data bits received
					next_state = STOP;
				end else begin
					next_state = DATA;
					bit_count = bit_count + 1'b1;
				end
			end
			STOP: begin
				if (in) begin // Stop bit correct
					next_state = IDLE;
				end else begin // Stop bit error
					next_state = ERROR;
				end
			end
            ERROR: begin
                next_state = WAIT_STOP;
            end
            WAIT_STOP: begin
                if (in) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP;
                end
            end

			default: begin
				next_state = IDLE;
			end
		endcase
	end

	assign done = done_reg;

endmodule