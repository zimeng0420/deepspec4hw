module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output [23:0] out_bytes,
	output done
);

	parameter IDLE = 2'b00;
	parameter FIRST = 2'b01;
	parameter SECOND = 2'b10;
	parameter THIRD = 2'b11;

	reg [1:0] state;
	reg [23:0] message;
	reg [7:0] byte1, byte2, byte3;
	reg done_r;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			done_r <= 0;
		end else begin
			case (state)
				IDLE: begin
					done_r <= 0;
					if (in[3]) begin
						byte1 <= in;
						state <= FIRST;
					end
				end
				FIRST: begin
					byte2 <= in;
					state <= SECOND;
				end
				SECOND: begin
					byte3 <= in;
					state <= THIRD;
				end
				THIRD: begin
					message[23:16] <= byte1;
					message[15:8] <= byte2;
					message[7:0] <= byte3;
					done_r <= 1;
					state <= IDLE;
				end
			endcase
		end
	end

	assign out_bytes = message;
	assign done = done_r;

endmodule