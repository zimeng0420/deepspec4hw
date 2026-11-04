module top_module (
	input clk,
	input reset,
	input x,
	output reg z
);

	reg [2:0] y; // Current state

	// State transition and output logic
	always @(posedge clk) begin
		if (reset) begin
			y <= 3'b000; // Reset to state 000
			z <= 0; // Output z is 0 on reset
		end else begin
			case (y)
				3'b000: begin
					if (x) begin
						y <= 3'b001; 
						z <= 0; 
					end else begin
						y <= 3'b000; 
						z <= 0; 
					end
				end

				3'b001: begin
					if (x) begin
						y <= 3'b100; 
						z <= 0; 
					end else begin
						y <= 3'b001; 
						z <= 0; 
					end
				end

				3'b010: begin
					if (x) begin
						y <= 3'b001; 
						z <= 0; 
					end else begin
						y <= 3'b010; 
						z <= 0; 
					end
				end

				3'b011: begin
					if (x) begin
						y <= 3'b010; 
						z <= 1; 
					end else begin
						y <= 3'b001; 
						z <= 1; 
					end
				end

				3'b100: begin
					if (x) begin
						y <= 3'b100; 
						z <= 1; 
					end else begin
						y <= 3'b011; 
						z <= 1; 
					end
				end

				default: begin
					y <= 3'b000; // Default case, should not occur
					z <= 0; 
				end
			endcase
		end
	end

endmodule