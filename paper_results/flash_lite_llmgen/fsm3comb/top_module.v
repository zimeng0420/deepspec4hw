module top_module (
	input in,
	input [1:0] state,
	output reg [1:0] next_state,
	output reg out
);

	always @(*) begin
		case (state)
			2'b00: // State A
				begin
					if (in == 0)
						next_state = 2'b00; // A
					else
						next_state = 2'b01; // B
					out = 0;
				end
			2'b01: // State B
				begin
					if (in == 0)
						next_state = 2'b10; // C
					else
						next_state = 2'b01; // B
					out = 0;
				end
			2'b10: // State C
				begin
					if (in == 0)
						next_state = 2'b00; // A
					else
						next_state = 2'b11; // D
					out = 0;
				end
			2'b11: // State D
				begin
					if (in == 0)
						next_state = 2'b10; // C
					else
						next_state = 2'b01; // B
					out = 1;
				end
			default: // Handle any unexpected state (shouldn't happen, but good practice)
				begin
					next_state = 2'b00; // Default to A
					out = 0;
				end
		endcase
	end

endmodule