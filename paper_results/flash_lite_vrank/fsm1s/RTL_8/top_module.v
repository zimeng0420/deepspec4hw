module top_module (
	input clk,
	input in,
	input reset,
	output out
);

	parameter A = 2'b00;
	parameter B = 2'b01;

	reg [1:0] state;
	reg out_reg;

	always @(posedge clk) begin
		if (reset) begin
			state <= B;
		end else begin
			case (state)
				B: state <= in ? B : A;
				A: state <= in ? A : B;
			endcase
		end
	end

	always @(*) begin
		case (state)
			B: out_reg = 1'b1;
			A: out_reg = 1'b0;
			default: out_reg = 1'b0;
		endcase
	end

	assign out = out_reg;

endmodule