module top_module(
	input clk,
	input load,
	input [255:0] data,
	output reg [255:0] q
);

	integer i, j, index;

	// Function to count neighbors considering the toroidal effect
	function [3:0] count_neighbors(input [255:0] grid, input integer i, input integer j);
		integer ni, nj, k, l;
		begin
			count_neighbors = 0;
			for (k = -1; k <= 1; k = k + 1) begin
				for (l = -1; l <= 1; l = l + 1) begin
					if (k != 0 || l != 0) begin // Exclude the cell itself
						ni = (i + k + 16) % 16;
						nj = (j + l + 16) % 16;
						count_neighbors = count_neighbors + grid[ni*16 + nj];
					end
				end
			end
		end
	endfunction

	always @(posedge clk) begin
		if (load) begin
			q <= data;
		end else begin
			reg [255:0] next_state;
			integer neighbors;
			for (i = 0; i < 16; i = i + 1) begin
				for (j = 0; j < 16; j = j + 1) begin
					index = i * 16 + j;
					neighbors = count_neighbors(q, i, j);
					case (neighbors)
						2: next_state[index] = q[index]; // Stay the same
						3: next_state[index] = 1'b1;    // Become alive
						default: next_state[index] = 1'b0; // Become dead
					endcase
				end
			end
			q <= next_state;
		end
	end

endmodule