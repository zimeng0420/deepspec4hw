module top_module (
	input clk,
	input in,
	input reset,
	output out
);

	parameter A = 0;
	parameter B = 1;

	reg [0:0] state;
	reg out_r;

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
			B: out_r = 1'b1;
			A: out_r = 1'b0;
			default: out_r = 1'b0; // Should not happen, but good practice
		endcase
	end

	assign out = out_r;

endmodule