module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output [23:0] out_bytes,
	output done
);

	parameter IDLE = 0;
	parameter SEARCH = 1;
	parameter RECEIVE1 = 2;
	parameter RECEIVE2 = 3;
	
	reg [1:0] state;
	reg [7:0] byte1, byte2, byte3;
	reg [23:0] out_bytes_reg;
	reg done_reg;
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			state <= IDLE;
			done_reg <= 0;
			out_bytes_reg <= 0;
		end else begin
			case (state)
				IDLE: begin
					done_reg <= 0;
					if (in[3]) begin
						byte1 <= in;
						state <= RECEIVE1;
					end else begin
						state <= IDLE;
					end
				end
				RECEIVE1: begin
					byte2 <= in;
					state <= RECEIVE2;
					done_reg <= 0;
				end
				RECEIVE2: begin
					byte3 <= in;
					state <= IDLE;
					done_reg <= 1;
					out_bytes_reg <= {byte1, byte2, byte3};
				end
			endcase
		end
	end
	
	assign out_bytes = out_bytes_reg;
	assign done = done_reg;
	
endmodule