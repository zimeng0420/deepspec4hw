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
					end else begin
						state <= A;
					end
				end
				B: begin
					w_history <= {w_history[1:0], w};
					if (count == 2) begin
						state <= E;
					end else begin
						state <= B;
					end
					count <= count + 1;
				end
				E: begin
					z <= (w_history[2] + w_history[1] + w_history[0] == 2) ? 1 : 0;
					state <= B;
					count <= 0;
					w_history <= 0;
				end
			endcase
		end
	end

endmodule