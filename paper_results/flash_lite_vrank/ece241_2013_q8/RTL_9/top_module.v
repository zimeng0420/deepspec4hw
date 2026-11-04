module top_module (
	input clk,
	input aresetn,
	input x,
	output reg z
);

	parameter S0 = 0, S1 = 1, S2 = 2;
	reg [1:0] state;

	always @(posedge clk or negedge aresetn) begin
		if (!aresetn) begin
			state <= S0;
			z <= 1'b0;
		end else begin
			case (state)
				S0: begin
					if (x)
						state <= S1;
					else
						state <= S0;
					z <= 1'b0;
				end
				S1: begin
					if (x)
						state <= S1;
					else
						state <= S2;
					z <= 1'b0;
				end
				S2: begin
					if (x)
						state <= S1;
					else
						state <= S0;
					z <= 1'b1;
				end
			endcase
		end
	end

endmodule