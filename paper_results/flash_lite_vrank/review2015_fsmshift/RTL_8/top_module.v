module top_module(
	input clk,
	input reset,
	output shift_ena
);

	parameter IDLE = 0;
	parameter SHIFT = 1;
	parameter DONE = 2;
	
	reg [1:0] state;
	reg [1:0] count;

	always @(posedge clk) begin
		if (reset) begin
			state <= SHIFT;
			count <= 2'd3;
		end else begin
			case (state)
				IDLE: begin
					state <= IDLE;
					count <= 2'd0;
				end
				SHIFT: begin
					state <= SHIFT;
					if (count > 0) begin
						count <= count - 1'b1;
					end else begin
						state <= DONE;
						count <= 2'd0;
					end
				end
				DONE: begin
					state <= IDLE;
					count <= 2'd0;
				end
			endcase
		end
	end
	
	assign shift_ena = (state == SHIFT) ;
	
endmodule