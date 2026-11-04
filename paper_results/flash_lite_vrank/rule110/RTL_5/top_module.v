module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q
);

	reg [511:0] next_q;

	always @(posedge clk) begin
		if (load) begin
			q <= data;
		end else begin
			// Calculate next state based on rule 110
			for (int i = 0; i < 512; i++) begin
				// Determine the neighbors, handling boundary conditions
				wire left  = (i == 0) ? 1'b0 : q[i-1];
				wire center = q[i];
				wire right = (i == 511) ? 1'b0 : q[i+1];

				// Apply the rule 110 lookup table
				case ({left, center, right})
					3'b111: next_q[i] = 1'b0;
					3'b110: next_q[i] = 1'b1;
					3'b101: next_q[i] = 1'b1;
					3'b100: next_q[i] = 1'b0;
					3'b011: next_q[i] = 1'b1;
					3'b010: next_q[i] = 1'b1;
					3'b001: next_q[i] = 1'b1;
					3'b000: next_q[i] = 1'b0;
					default: next_q[i] = 1'b0; // Default case (shouldn't happen)
				endcase
			end
			q <= next_q;
		end
	end

endmodule