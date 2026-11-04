module top_module (
	input clk,
	input j,
	input k,
	input reset,
	output out
);

	// State definition
	parameter OFF = 0;
	parameter ON  = 1;

	// State register
	reg state;

	// Output register
	assign out = state;

	// State transition logic
	always @(posedge clk) begin
		if (reset) begin
			state <= OFF;
		end else begin
			case (state)
				OFF: begin
					if (j)
						state <= ON;
					else
						state <= OFF;
				end
				ON: begin
					if (k)
						state <= OFF;
					else
						state <= ON;
				end
				default:
					state <= OFF; // Default state (should not happen)
			endcase
		end
	end

endmodule