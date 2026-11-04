module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output done
);

	parameter IDLE = 2'b00;
	parameter BYTE1 = 2'b01;
	parameter BYTE2 = 2'b10;
	parameter BYTE3 = 2'b11;

	reg [1:0] state;
	reg [7:0] byte1, byte2, byte3;
	reg [1:0] byte_count;
	reg done_reg;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			done_reg <= 1'b0;
			byte_count <= 2'b00;
		end else begin
			done_reg <= 1'b0;
			case (state)
				IDLE: begin
					if (in[3]) begin
						state <= BYTE1;
						byte1 <= in;
						byte_count <= 2'b01;
					end
				end
				BYTE1: begin
					state <= BYTE2;
					byte2 <= in;
					byte_count <= 2'b10;
				end
				BYTE2: begin
					state <= BYTE3;
					byte3 <= in;
					byte_count <= 2'b11;
				end
				BYTE3: begin
					state <= IDLE;
					done_reg <= 1'b1;
					byte_count <= 2'b00;
				end
			endcase
		end
	end

	assign done = done_reg;

endmodule