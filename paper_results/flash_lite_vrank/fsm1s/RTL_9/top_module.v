module top_module (
	input clk,
	input in,
	input reset,
	output out
);

	parameter A = 2'b00;
	parameter B = 2'b01;
	reg [1:0] state, next_state;
	
	always @(posedge clk) begin
		if (reset)
			state <= B;
		else
			state <= next_state;
	end
	
	always @(*) begin
		case (state)
			B:
				if (in)
					next_state = B;
				else
					next_state = A;
			A:
				if (in)
					next_state = A;
				else
					next_state = B;
			default:
				next_state = B;
		endcase
	end
	
	always @(*) begin
		case (state)
			B:
				out = 1'b1;
			A:
				out = 1'b0;
			default:
				out = 1'b1;
		endcase
	end
	
endmodule