module top_module (
	input clk,
	input in,
	input areset,
	output out
);

	parameter A = 2'b00;
	parameter B = 2'b01;

	reg [1:0] state;
	reg out_reg;

	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= B;
			out_reg <= 1'b1;
		end else begin
			case (state)
				A: begin
					if (in) begin
						state <= A;
					end else begin
						state <= B;
					end
					out_reg <= 1'b0;
				end
				B: begin
					if (in) begin
						state <= B;
					end else begin
						state <= A;
					end
					out_reg <= 1'b1;
				end
			endcase
		end
	end

	assign out = out_reg;

endmodule