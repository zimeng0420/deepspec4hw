module top_module (
	input clk,
	input reset,
	input s,
	input w,
	output reg z
);

	parameter A = 0, B = 1, C1 = 2, C2 = 3, C3 = 4, D = 5;
	reg [2:0] state;
	reg [2:0] count;
	reg w_reg1, w_reg2, w_reg3;

	always @(posedge clk) begin
		if (reset) begin
			state <= A;
			z <= 0;
			count <= 0;
		end else begin
			case (state)
				A: begin
					z <= 0;
					if (s) begin
						state <= B;
						count <= 0;
						w_reg1 <= w;
						w_reg2 <= 0;
						w_reg3 <= 0;
					end else begin
						state <= A;
					end
				end
				B: begin
					z <= 0;
					w_reg1 <= w;
					state <= C1;
				end
				C1: begin
					w_reg2 <= w;
					state <= C2;
				end
				C2: begin
					w_reg3 <= w;
					state <= D;
				end
				D: begin
					z <= (w_reg1 + w_reg2 + w_reg3 == 2);
					state <= B;
				end
			endcase
		end
	end

endmodule