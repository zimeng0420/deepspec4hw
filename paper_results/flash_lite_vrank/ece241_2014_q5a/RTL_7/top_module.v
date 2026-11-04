module top_module (
	input clk,
	input areset,
	input x,
	output z
);

	parameter S_INIT = 0;
	parameter S_SEARCH = 1;
	parameter S_COMPLEMENT = 2;

	reg [1:0] state;
	reg z_reg;
	reg carry;

	always @(posedge clk or negedge areset) begin
		if (!areset) begin
			state <= S_INIT;
			z_reg <= 1'b0;
			carry <= 1'b1;
		end else begin
			case (state)
				S_INIT: begin
					state <= S_SEARCH;
					z_reg <= x;
					carry <= ~x;
				end
				S_SEARCH: begin
					if (x) begin
						state <= S_COMPLEMENT;
						z_reg <= ~x ^ carry;
						carry <= carry & x;
					end else begin
						z_reg <= x;
						carry <= carry;
					end
				end
				S_COMPLEMENT: begin
					z_reg <= ~x ^ carry;
					carry <= carry & x;
					if (carry) begin
						state <= S_COMPLEMENT; //stay in the same state if carry = 1
					end else begin
						state <= S_COMPLEMENT; //continue complementing until reset
					end
				end
				default: begin
					state <= S_INIT;
					z_reg <= 1'b0;
					carry <= 1'b1;
				end
			endcase
		end
	end

	assign z = z_reg;

endmodule