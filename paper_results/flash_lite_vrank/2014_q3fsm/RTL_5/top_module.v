module top_module (
	input clk,
	input reset,
	input s,
	input w,
	output reg z
);

	parameter A = 0;
	parameter B = 1;
	parameter C = 2;
	parameter D = 3;
	parameter E = 4;

	reg [2:0] state;
	reg [2:0] count;
	reg [2:0] w_history;

	always @(posedge clk) begin
		if (reset) begin
			state <= A;
			count <= 3'b000;
			w_history <= 3'b000;
			z <= 1'b0;
		end else begin
			case (state)
				A: begin
					z <= 1'b0;
					if (s) begin
						state <= B;
						count <= 3'b000;
						w_history <= 3'b000;
					end else
						state <= A;
				end
				B: begin
					w_history <= {w_history[1:0], w};
					if (count < 3) begin
						count <= count + 1;
						z <= 1'b0;

					end else begin
                        // Check for two 1s in w_history
                        if (w_history[0] + w_history[1] + w_history[2] == 2) begin
                            z <= 1'b1;
						end
                        else begin
                            z <= 1'b0;
                        end

                        state <= B;
						count <= 3'b000;
						w_history <= 3'b000;
                    end
				end
			endcase
		end
	end

endmodule