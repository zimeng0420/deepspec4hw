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
		if (areset)
			state <= B;
		else
			case (state)
				A:  begin
					if (in)
						state <= A;
					else
						state <= B;
				end
				B:  begin
					if (in)
						state <= B;
					else
						state <= A;
				end
			endcase
	end

	always @(*) begin
		case (state)
			A: out_reg = 1'b0;
			B: out_reg = 1'b1;
			default: out_reg = 1'bx;
		endcase
	end

	assign out = out_reg;

endmodule