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
	parameter WAIT_STOP = 4;

	reg [2:0] state;
	reg [7:0] data_reg;
	reg [2:0] bit_count;
	reg done_reg;
    reg in_reg;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			data_reg <= 8'b0;
			bit_count <= 3'b0;
			done_reg <= 1'b0;
            in_reg <= 1'b1; // Assume idle state is high
		end else begin
            in_reg <= in;
			case (state)
				IDLE: begin
					done_reg <= 1'b0;
					if (!in) begin // Start bit detected (0)
						state <= START;
					end
				end
				START: begin
					if (in) begin // Check if the start bit is correct
						state <= IDLE; // Go back to idle if not a valid start bit
					end else {
                        state <= DATA;
                    }
				end
				DATA: begin
					data_reg <= {in, data_reg[7:1]}; // Shift in the data
					bit_count <= bit_count + 1;
					if (bit_count == 3'b111) begin // After 8 bits
						state <= STOP;
						bit_count <= 3'b0;
					end
				end
				STOP: begin
					if (in) begin // Check for stop bit (1)
						done_reg <= 1'b1;
						state <= IDLE;
					end else begin
						state <= WAIT_STOP; // if stop bit is incorrect
					end
				end
				WAIT_STOP: begin
                    done_reg <= 1'b0;
					if (in) begin // Wait until a stop bit arrives.
						state <= IDLE;
					end
				end
			endcase
		end
	end

	assign out_byte = data_reg;
	assign done = done_reg;

endmodule