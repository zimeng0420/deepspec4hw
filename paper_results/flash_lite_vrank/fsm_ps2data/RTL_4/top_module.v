module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output [23:0] out_bytes,
	output done
);

	// State Definitions
	localparam IDLE = 0;
	localparam RECEIVE1 = 1;
	localparam RECEIVE2 = 2;
	localparam RECEIVE3 = 3;

	// Internal Signals
	reg [1:0] state;
	reg [23:0] byte_buffer;
	reg done_reg;

	// State Transition Logic
	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			done_reg <= 0;
		end else begin
			case (state)
				IDLE: begin
					done_reg <= 0;
					if (in[3]) begin
						byte_buffer[23:16] <= in;
						state <= RECEIVE1;
					end
				end
				RECEIVE1: begin
					byte_buffer[15:8] <= in;
					state <= RECEIVE2;
				end
				RECEIVE2: begin
					byte_buffer[7:0] <= in;
					state <= RECEIVE3;
				end
				RECEIVE3: begin
					done_reg <= 1;
					state <= IDLE;
				end
			endcase
		end
	end

	// Output Logic
	assign out_bytes = byte_buffer;
	assign done = done_reg;

endmodule