module top_module(
	input clk,
	input load,
	input [255:0] data,
	output reg [255:0] q
);

	reg [255:0] next_q;
	
	always @(posedge clk) begin
		if (load)
			q <= data;
		else
			q <= next_q;
	end
	
	always @(*) begin
		integer i, j, row, col, neighbor_count;
		next_q = q; // Default: keep the same state
		
		for (i = 0; i < 16; i = i + 1) begin  // Iterate through rows
			for (j = 0; j < 16; j = j + 1) begin  // Iterate through columns
				row = i;
				col = j;
				neighbor_count = 0;

				// Count neighbors - using modular arithmetic for toroidal wrap-around
				neighbor_count = 
					q[((row - 1 + 16) % 16) * 16 + ((col - 1 + 16) % 16)] + // Top Left
					q[((row - 1 + 16) % 16) * 16 + ((col + 0 + 16) % 16)] + // Top
					q[((row - 1 + 16) % 16) * 16 + ((col + 1 + 16) % 16)] + // Top Right
					q[((row + 0 + 16) % 16) * 16 + ((col - 1 + 16) % 16)] + // Left
					q[((row + 0 + 16) % 16) * 16 + ((col + 1 + 16) % 16)] + // Right
					q[((row + 1 + 16) % 16) * 16 + ((col - 1 + 16) % 16)] + // Bottom Left
					q[((row + 1 + 16) % 16) * 16 + ((col + 0 + 16) % 16)] + // Bottom
					q[((row + 1 + 16) % 16) * 16 + ((col + 1 + 16) % 16)];  // Bottom Right

				// Apply game rules
				if (q[i * 16 + j] == 1) begin // Cell is alive
					if (neighbor_count <= 1 || neighbor_count >= 4)
						next_q[i * 16 + j] = 0; // Dies
				end else begin // Cell is dead
					if (neighbor_count == 3)
						next_q[i * 16 + j] = 1; // Becomes alive
				end
			end
		end
	end
endmodule