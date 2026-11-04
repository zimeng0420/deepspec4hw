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
			// Calculate the next state based on the current state.
			for (i = 0; i < 16; i = i + 1) begin
				for (j = 0; j < 16; j = j + 1) begin
					row = i;
					col = j;
					neighbor_count = 0;

					// Count neighbors
					neighbor_count = 0;
					// Check all 8 neighbors, using toroidal boundary conditions.
					neighbor_count = neighbor_count + q[((row - 1 + 16) % 16) * 16 + ((col - 1 + 16) % 16)];
					neighbor_count = neighbor_count + q[((row - 1 + 16) % 16) * 16 + ((col + 0 + 16) % 16)];
					neighbor_count = neighbor_count + q[((row - 1 + 16) % 16) * 16 + ((col + 1 + 16) % 16)];
					neighbor_count = neighbor_count + q[((row + 0 + 16) % 16) * 16 + ((col - 1 + 16) % 16)];
					neighbor_count = neighbor_count + q[((row + 0 + 16) % 16) * 16 + ((col + 1 + 16) % 16)];
					neighbor_count = neighbor_count + q[((row + 1 + 16) % 16) * 16 + ((col - 1 + 16) % 16)];
					neighbor_count = neighbor_count + q[((row + 1 + 16) % 16) * 16 + ((col + 0 + 16) % 16)];
					neighbor_count = neighbor_count + q[((row + 1 + 16) % 16) * 16 + ((col + 1 + 16) % 16)];


					// Determine next state based on neighbor count.
					if (q[i * 16 + j] == 1) begin  // Current cell is alive
						if (neighbor_count < 2 || neighbor_count > 3) begin
							next_q[i * 16 + j] <= 0;
						end else begin
							next_q[i * 16 + j] <= 1;
						end
					end else begin  // Current cell is dead
						if (neighbor_count == 3) begin
							next_q[i * 16 + j] <= 1;
						end else begin
							next_q[i * 16 + j] <= 0;
						end
					end
				end
			end
			q <= next_q;
		end
	end

endmodule