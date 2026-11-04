module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output out
);

	parameter OFF = 0;
	parameter ON = 1;

	reg [1:0] state;
	reg out_reg;

	always @(posedge clk or posedge areset) begin
		if (areset)
			state <= OFF;
		else begin
			case (state)
				OFF:
					if (j)
						state <= ON;
					else
						state <= OFF;
				ON:
					if (k)
						state <= OFF;
					else
						state <= ON;
				default:
					state <= OFF;
			endcase
		end
	end

	always @(*) begin
		case (state)
			OFF:
				out_reg = 0;
			ON:
				out_reg = 1;
			default:
				out_reg = 0;
		endcase
	end

	assign out = out_reg;

endmodule