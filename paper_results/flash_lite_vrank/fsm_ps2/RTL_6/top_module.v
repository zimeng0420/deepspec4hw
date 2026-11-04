module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output done
);

	parameter IDLE = 2'b00;
	parameter FIRST = 2'b01;
	parameter SECOND = 2'b10;
	parameter THIRD = 2'b11;

	reg [1:0] state;
	reg [1:0] next_state;
	reg [7:0] byte1, byte2, byte3;
	reg done_reg;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			done_reg <= 1'b0;
		end else begin
			state <= next_state;
			done_reg <= (next_state == THIRD);
		end
	end

	always @(*) begin
		next_state = state;
		case (state)
			IDLE: begin
				done_reg = 1'b0;
				if (in[3]) begin
					next_state = FIRST;
					byte1 = in;
				end
			end
			FIRST: begin
				next_state = SECOND;
				byte2 = in;
			end
			SECOND: begin
				next_state = THIRD;
				byte3 = in;
			end
			THIRD: begin
				next_state = IDLE;
			end
			default: next_state = IDLE;
		endcase
	end

	assign done = done_reg;

endmodule