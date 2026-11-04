module top_module (
	input clk,
	input reset,
	input s,
	input w,
	output reg z
);

	parameter A = 0, B = 1, C = 2, D = 3, E = 4;
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
					count <= count + w;
					state <= C;
				end
				C: begin
					w_history <= {w_history[1:0], w};
					count <= count + w;
					state <= D;

				end
				D: begin
					w_history <= {w_history[1:0], w};
					count <= count + w;
					state <= E;
				end
				E: begin
					z <= (count == 2) ? 1 : 0;
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