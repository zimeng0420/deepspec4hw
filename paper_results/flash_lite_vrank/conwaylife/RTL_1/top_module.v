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
		next_q = q; // Default: no change
		
		for (i = 0; i < 16; i = i + 1) begin // Iterate through rows
			for (j = 0; j < 16; j = j + 1) begin // Iterate through columns
				neighbor_count = 0;
				// Calculate neighbors
				for (integer x = -1; x <= 1; x = x + 1) begin
					for (integer y = -1; y <= 1; y = y + 1) begin
						if (x == 0 && y == 0) continue; // Skip the cell itself
						
						row = i + x;
						col = j + y;
						
						// Handle toroidal boundary conditions
						if (row < 0) row = 15;
						if (row > 15) row = 0;
						if (col < 0) col = 15;
						if (col > 15) col = 0;
						
						neighbor_count = neighbor_count + q[row*16 + col];
					end
				end
				
				// Apply Conway's rules
				if (q[i*16 + j] == 1) begin // Cell is alive
					if (neighbor_count <= 1 || neighbor_count >= 4)
						next_q[i*16 + j] = 0; // Dies
				end else begin // Cell is dead
					if (neighbor_count == 3)
						next_q[i*16 + j] = 1; // Becomes alive
				end
			end
		end
	end

endmodule