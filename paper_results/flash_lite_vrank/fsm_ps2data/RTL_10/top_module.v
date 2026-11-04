module top_module (
	input clk,
	input [7:0] in,
	input reset,
	output [23:0] out_bytes,
	output done
);

	parameter IDLE = 2'b00;
	parameter READ1 = 2'b01;
	parameter READ2 = 2'b10;
	parameter DONE_STATE = 2'b11;

	reg [1:0] state;
	reg [23:0] message;
	reg [7:0] byte1, byte2, byte3;
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
						byte1 <= in;
						state <= READ1;
					end
				end
				READ1: begin
					byte2 <= in;
					state <= READ2;
				end
				READ2: begin
					byte3 <= in;
					state <= DONE_STATE;
				end
				DONE_STATE: begin
					done_reg <= 1;
					state <= IDLE;
				end
			endcase
		end
	end

	always @(*) begin
		case (state)
			IDLE: message = 24'b0;
			READ1: message = {byte1, 8'b0, 8'b0};
			READ2: message = {byte1, byte2, 8'b0};
			DONE_STATE: message = {byte1, byte2, byte3};
			default: message = 24'b0;
		endcase
	end

	assign out_bytes = message;
	assign done = done_reg;

endmodule