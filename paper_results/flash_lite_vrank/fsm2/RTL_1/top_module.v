module top_module (
	input clk,
	input j,
	input k,
	input areset,
	output reg out
);

	// Define states
	parameter OFF = 0;
	parameter ON = 1;

	// Define state register
	reg [1:0] state; // Using 2 bits for potential future state expansion

	// State transition logic
	always @(posedge clk or posedge areset) begin
		if (areset) begin
			state <= OFF;
			out <= 0;
		end else begin
			case (state)
				OFF: begin
					if (j) begin
						state <= ON;
					end else begin
						state <= OFF;
					end
				end
				ON: begin
					if (k) begin
						state <= OFF;
					end else begin
						state <= ON;
					end
				end
			endcase
		end
	end

	// Output logic
	always @(*) begin
		case (state)
			OFF: out = 0;
			ON: out = 1;
			default: out = 0; // Default case for safety (should never happen)
		endcase
	end

endmodule