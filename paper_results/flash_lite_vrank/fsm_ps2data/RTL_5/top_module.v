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
	parameter DONE = 2'b11;

	reg [1:0] state, next_state;
	reg [7:0] byte1, byte2;
	reg [23:0] out_bytes_reg;
	reg done_reg;

	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			done_reg <= 0;
		end else begin
			state <= next_state;
			done_reg <= (state == DONE);
		end
	end

	always @(*) begin
		next_state = state;
		out_bytes_reg = out_bytes_reg;
		case (state)
			IDLE: begin
				if (in[3]) begin
					next_state = READ1;
				end
			end
			READ1: begin
				next_state = READ2;
				byte1 = in;
			end
			READ2: begin
				next_state = DONE;
				byte2 = in;
			end
			DONE: begin
				next_state = IDLE;
				out_bytes_reg[23:16] = byte1;
				out_bytes_reg[15:8] = byte2;
				out_bytes_reg[7:0] = in;
			end
			default: begin
				next_state = IDLE;
			end
		endcase
	end

	assign out_bytes = out_bytes_reg;
	assign done = done_reg;
	
endmodule