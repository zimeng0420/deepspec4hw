module top_module (
	input clk,
	input aresetn,
	input x,
	output reg z
);

	parameter S0 = 0;
	parameter S1 = 1;
	parameter S2 = 2;

	reg [1:0] state;

	always @(posedge clk, negedge aresetn) begin
		if (!aresetn)
			state <= S0;
		else
			case (state)
				S0: begin
					if (x)
						state <= S1;
					else
						state <= S0;
				end
				S1: begin
					if (x)
						state <= S1;
					else
						state <= S2;
				end
				S2: begin
					if (x)
						state <= S1;
					else
						state <= S0;
				end
			endcase
	end

	always @(*) begin
		case (state)
			S0: z = 0;
			S1: z = 0;
			S2: z = 1;
			default: z = 0;
		endcase
	end

endmodule