module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

	always @(*) begin
		case (state)
			4'b0001:  // A
				next_state = (in) ? 4'b0010 : 4'b0001;  // in ? B : A
			4'b0010:  // B
				next_state = (in) ? 4'b0100 : 4'b0010;  // in ? C : B
			4'b0100:  // C
				next_state = (in) ? 4'b1000 : 4'b0001;  // in ? D : A
			4'b1000:  // D
				next_state = (in) ? 4'b0010 : 4'b0100;  // in ? B : C
			default:
				next_state = 4'b0001; // Default to state A
		endcase
	end

	always @(*) begin
		case (state)
			4'b1000:  // D
				out = 1;
			default:
				out = 0;
		endcase
	end

endmodule