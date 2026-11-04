module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output reg [23:0] out_bytes,
	output reg done
);

	reg [1:0] state, next_state;
	reg [23:0] message;
	reg [1:0] byte_count;

	localparam WAIT = 2'b00, BYTE_1 = 2'b01, BYTE_2 = 2'b10, BYTE_3 = 2'b11;

	always @(posedge clk) begin
		if (reset) begin
			state <= WAIT;
			done <= 0;
			message <= 24'b0;
			byte_count <= 2'b0;
		end else begin
			state <= next_state;
		end
	end

	always @(*) begin
		next_state = state;
		done = 0;
		out_bytes = 24'bx;

		case (state)
			WAIT: begin
				if (in[3]) begin
					next_state = BYTE_1;
					message[23:16] = in;
					byte_count = 2'b01;
				end
			end
			BYTE_1: begin
				next_state = BYTE_2;
				message[15:8] = in;
				byte_count = 2'b10;
			end
			BYTE_2: begin
				next_state = BYTE_3;
				message[7:0] = in;
				byte_count = 2'b11;
			end
			BYTE_3: begin
				done = 1;
				out_bytes = message;
				next_state = WAIT;
			end
		endcase
	end
	
endmodule