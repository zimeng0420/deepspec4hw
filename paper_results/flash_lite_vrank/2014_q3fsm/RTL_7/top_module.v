module top_module (
	input clk,
	input reset,
	input s,
	input w,
	output reg z
);

	parameter A = 2'b00;
	parameter B = 2'b01;
	parameter C = 2'b10;
	parameter D = 2'b11;

	reg [1:0] state;
	reg [2:0] w_count;
	reg [2:0] w_history;

	always @(posedge clk) begin
		if (reset) begin
			state <= A;
			z <= 0;
			w_count <= 0;
			w_history <= 0;
		end else begin
			case (state)
				A: begin
					z <= 0;
					if (s) begin
						state <= B;
						w_count <= 0;
						w_history <= 0;
					end else begin
						state <= A;
					end
				end

				B: begin
					w_history <= {w_history[1:0], w};
					if (w_history[2] == 1) w_count <= w_count + 1;
					if (w_history[1] == 1) w_count <= w_count + 1;
					if (w_history[0] == 1) w_count <= w_count + 1;

					state <= C;
				end
                
				C: begin
					if (w_count == 2) begin
						z <= 1;
					end else begin
						z <= 0;
					end
					state <= B;
					w_count <= 0;
					w_history <= 0;
				end
			endcase
		end
	end

endmodule