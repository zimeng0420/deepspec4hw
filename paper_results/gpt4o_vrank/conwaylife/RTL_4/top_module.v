module top_module(
	input clk,
	input load,
	input [255:0] data,
	output reg [255:0] q);

    // Temporary registers for processing
    reg [255:0] next_q;

	// Function to count the number of alive neighbours
	function [3:0] count_neighbours;
		input [255:0] q;
		input [4:0] row, col;
		integer i, j;
		begin
			count_neighbours = 0;
			for (i = -1; i <= 1; i = i + 1) begin
				for (j = -1; j <= 1; j = j + 1) begin
					if (i != 0 || j != 0) begin
						count_neighbours = count_neighbours + q[((row + i + 16) % 16) * 16 + ((col + j + 16) % 16)];
					end
				end
			end
		end
	endfunction

	// Always block to compute the next state of the grid
	always @(posedge clk) begin
		if (load) begin
			q <= data; // Load data if load is high
		end else begin
			integer row, col;
			for (row = 0; row < 16; row = row + 1) begin
				for (col = 0; col < 16; col = col + 1) begin
					case (count_neighbours(q, row, col))
						0, 1: next_q[row * 16 + col] = 0;
						2: next_q[row * 16 + col] = q[row * 16 + col];
						3: next_q[row * 16 + col] = 1;
						default: next_q[row * 16 + col] = 0;
					endcase
				end
			end
			q <= next_q; // Update the grid state
		end
	end
endmodule