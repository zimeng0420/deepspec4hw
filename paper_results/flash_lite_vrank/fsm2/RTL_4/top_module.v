module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output out
);

	parameter OFF = 0;
	parameter ON = 1;

	reg [1:0] state, next_state;
	reg out_reg;

	always @(posedge clk or posedge areset) begin
		if (areset)
			state <= OFF;
		else
			state <= next_state;
	end

	always @(*) begin
		case (state)
			OFF:
				begin
					out_reg = 0;
					if (j)
						next_state = ON;
					else
						next_state = OFF;
				end
			ON:
				begin
					out_reg = 1;
					if (k)
						next_state = OFF;
					else
						next_state = ON;
				end
			default:
				next_state = OFF;
		endcase
	end
	
	assign out = out_reg;

endmodule