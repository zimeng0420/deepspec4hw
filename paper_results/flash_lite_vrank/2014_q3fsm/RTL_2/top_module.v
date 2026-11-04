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
	reg [2:0] w_history;

	always @(posedge clk) begin
		if (reset) begin
			state <= A;
			z <= 0;
			count <= 0;
			w_history <= 0;
		end else begin
			case (state)
				A: begin
					z <= 0;
					if (s) begin
						state <= B;
						count <= 0;
						w_history <= 0;
					end
				end
				B: begin
					w_history <= {w_history[1:0], w};
					if (count == 2) begin
						if (w_history[2] + w_history[1] + w_history[0] == 2)
							state <= D;
						else
							state <= D;
					end else begin
						state <= B;
					end
					count <= count + 1;
				end
				D: begin
					z <= (w_history[2] + w_history[1] + w_history[0] == 2);
					state <= B;
					count <= 0;
					w_history <= 0;
				end
				default: begin
					state <= A;
					z <= 0;
					count <= 0;
					w_history <= 0;
				end
			endcase
		end
	end

endmodule