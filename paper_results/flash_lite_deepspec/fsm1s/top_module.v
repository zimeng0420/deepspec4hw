module top_module (
	input clk,
	input in,
	input reset,
	output out
);

	// State encoding
	parameter A = 0;
	parameter B = 1;

	// State register
	reg state;

	// Output register
	reg out_reg;

	// Next state logic
	always @(posedge clk) begin
		if (reset) begin
			state <= B;
		end else begin
			case (state)
				A: begin
					if (in)
						state <= A;
					else
						state <= B;
				end
				B: begin
					if (in)
						state <= B;
					else
						state <= A;
				end
				default:
					state <= B; // Default to B for safety
			endcase
		end
	end

	// Output logic
	always @(*) begin
		case (state)
			A: out_reg = 0;
			B: out_reg = 1;
			default: out_reg = 1; // Default to 1 for safety
		endcase
	end

	assign out = out_reg;

endmodule