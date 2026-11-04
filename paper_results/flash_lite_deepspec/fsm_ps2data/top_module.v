module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output [23:0] out_bytes,
	output done
);

	// States
	parameter IDLE = 2'b00;
	parameter BYTE1_RECEIVED = 2'b01;
	parameter BYTE2_RECEIVED = 2'b10;
	parameter DONE_STATE = 2'b11;

	// Internal signals
	reg [1:0] state;
	reg [7:0] byte1, byte2, byte3;
	reg [23:0] out_bytes_internal;
	reg done_internal;
	reg [1:0] byte_count;

	// State transition logic and output logic
	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			byte1 <= 8'b0;
			byte2 <= 8'b0;
			byte3 <= 8'b0;
			out_bytes_internal <= 24'b0;
			done_internal <= 1'b0;
			byte_count <= 2'b00;
		end else begin
			case (state)
				IDLE: begin
					done_internal <= 1'b0;
					if (in[3]) begin
						byte1 <= in;
						state <= BYTE1_RECEIVED;
						byte_count <= 1;
					end
				end
				BYTE1_RECEIVED: begin
					byte2 <= in;
					state <= BYTE2_RECEIVED;
					byte_count <= 2;
				end
				BYTE2_RECEIVED: begin
					byte3 <= in;
					out_bytes_internal <= {byte1, byte2, byte3};
					state <= DONE_STATE;
					byte_count <= 3;
				end
				DONE_STATE: begin
					done_internal <= 1'b1;
					state <= IDLE;
					byte_count <= 0;
				end
				default: begin
					state <= IDLE;
					done_internal <= 1'b0;
					byte_count <= 0;
				end
			endcase
		end
	end

	// Output assignments
	assign out_bytes = (done_internal) ? out_bytes_internal : 24'b0;
	assign done = done_internal;

endmodule