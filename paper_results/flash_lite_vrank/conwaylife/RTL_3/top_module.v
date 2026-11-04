module top_module(
	input clk,
	input load,
	input [255:0] data,
	output reg [255:0] q);

	reg [255:0] next_q;
	integer i, j, row, col, neighbor_count;

	always @(posedge clk) begin
		if (load) begin
			q <= data;
		end else begin
			q <= next_q;
		end
	end

	always @(*) begin
		next_q = q;  // Initialize next_q with current state

		for (i = 0; i < 16; i = i + 1) begin
			for (j = 0; j < 16; j = j + 1) begin
				neighbor_count = 0;
				// Calculate neighbors
				for (row = i - 1; row <= i + 1; row = row + 1) begin
					for (col = j - 1; col <= j + 1; col = col + 1) begin
						if ((row == i) && (col == j)) begin
							// Skip the cell itself
						end else begin
							// Wrap around the grid
							integer r = (row < 0) ? 15 : (row > 15) ? 0 : row;
							integer c = (col < 0) ? 15 : (col > 15) ? 0 : col;

							neighbor_count = neighbor_count + q[r*16 + c];
						end
					end
				end

				// Apply Conway's rules
				if (q[i*16 + j] == 1) begin
					if (neighbor_count <= 1 || neighbor_count >= 4) begin
						next_q[i*16 + j] = 0;
					end
				end else begin // q[i*16 + j] == 0
					if (neighbor_count == 3) begin
						next_q[i*16 + j] = 1;
					end
				end
			end
		end
	end

endmodule