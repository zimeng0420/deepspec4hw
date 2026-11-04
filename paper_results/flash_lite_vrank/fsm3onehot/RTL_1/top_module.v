module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

	always @(*) begin
		case (state)
			4'b0001: // A
				next_state = (in) ? 4'b0010 : 4'b0001; // B or A
			4'b0010: // B
				next_state = (in) ? 4'b0100 : 4'b0010; // C or B
			4'b0100: // C
				next_state = (in) ? 4'b1000 : 4'b0001; // D or A
			4'b1000: // D
				next_state = (in) ? 4'b0010 : 4'b0100; // B or C
			default:
				next_state = 4'b0001; // Default to A
		endcase
	end

	always @(*) begin
		case (state)
			4'b1000: // D
				out = 1'b1;
			default:
				out = 1'b0;
		endcase
	end

endmodule