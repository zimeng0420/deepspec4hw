module top_module(
	input clk,
	input load,
	input [255:0] data,
	output reg [255:0] q
);

	reg [255:0] next_q;
	integer i, j, row, col, neighbor_count;

	always @(posedge clk) begin
		if (load) begin
			q <= data;
		end else begin
			// Calculate next state
			for (i = 0; i < 16; i = i + 1) begin
				for (j = 0; j < 16; j = j + 1) begin
					neighbor_count = 0;
					// Count neighbors (toroidal)
					for (row = -1; row <= 1; row = row + 1) begin
						for (col = -1; col <= 1; col = col + 1) begin
							if (row == 0 && col == 0) begin
								continue; // Skip the cell itself
							end
							neighbor_count = neighbor_count + q[((i + row + 16) % 16) * 16 + ((j + col + 16) % 16)];
						end
					end

					// Apply game rules
					case (neighbor_count)
						0, 1: next_q[i * 16 + j] = 0;
						2:      next_q[i * 16 + j] = q[i * 16 + j];
						3:      next_q[i * 16 + j] = 1;
						default: next_q[i * 16 + j] = 0; // 4+ neighbors
					endcase
				end
			end
			q <= next_q;
		end
	end

endmodule