module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output [23:0] out_bytes,
	output done
);

	parameter IDLE = 0,
              BYTE1 = 1,
              BYTE2 = 2,
              BYTE3 = 3;

	reg [1:0] state;
	reg [23:0] out_bytes_reg;
	reg done_reg;
	reg [7:0] byte1, byte2, byte3;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			done_reg <= 0;
		end else begin
			case (state)
				IDLE: begin
					done_reg <= 0;
					if (in[3]) begin
						state <= BYTE1;
						byte1 <= in;
					end
				end
				BYTE1: begin
					state <= BYTE2;
					byte2 <= in;
				end
				BYTE2: begin
					state <= BYTE3;
					byte3 <= in;
				end
				BYTE3: begin
					state <= IDLE;
					done_reg <= 1;
					out_bytes_reg[23:16] <= byte1;
					out_bytes_reg[15:8] <= byte2;
					out_bytes_reg[7:0] <= byte3;
				end
			endcase
		end
	end

	assign out_bytes = out_bytes_reg;
	assign done = done_reg;

endmodule