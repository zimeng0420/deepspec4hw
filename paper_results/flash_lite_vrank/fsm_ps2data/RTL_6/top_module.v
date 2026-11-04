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
	reg done_reg;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			done_reg <= 0;
		end else begin
			case (state)
				IDLE: begin
					done_reg <= 0;
					if (in[3]) begin
						state <= FIRST;
						message[23:16] <= in;
					end
				end
				FIRST: begin
					message[15:8] <= in;
					state <= SECOND;
					done_reg <= 0;
				end
				SECOND: begin
					message[7:0] <= in;
					state <= THIRD;
					done_reg <= 0;
				end
				THIRD: begin
					state <= IDLE;
					done_reg <= 1;
				end
			endcase
		end
	end

	assign out_bytes = message;
	assign done = done_reg;

endmodule