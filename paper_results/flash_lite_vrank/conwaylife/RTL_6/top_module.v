module top_module(
	input clk,
	input load,
	input [255:0] data,
	output reg [255:0] q
);

	reg [255:0] next_q;
	
	always @(posedge clk) begin
		if (load) begin
			q <= data;
		end else begin
			q <= next_q;
		end
	end

	always @(*) begin
		integer i, j;
		integer neighbor_count;
		
		for (i = 0; i < 16; i = i + 1) begin
			for (j = 0; j < 16; j = j + 1) begin
				neighbor_count = 0;
				
				// Calculate neighbor indices with toroidal boundary conditions
				integer row_above = (i == 0) ? 15 : i - 1;
				integer row_below = (i == 15) ? 0 : i + 1;
				integer col_left  = (j == 0) ? 15 : j - 1;
				integer col_right = (j == 15) ? 0 : j + 1;

				// Count neighbors
				neighbor_count = neighbor_count + q[row_above * 16 + col_left];
				neighbor_count = neighbor_count + q[row_above * 16 + j];
				neighbor_count = neighbor_count + q[row_above * 16 + col_right];
				neighbor_count = neighbor_count + q[i * 16 + col_left];
				neighbor_count = neighbor_count + q[i * 16 + col_right];
				neighbor_count = neighbor_count + q[row_below * 16 + col_left];
				neighbor_count = neighbor_count + q[row_below * 16 + j];
				neighbor_count = neighbor_count + q[row_below * 16 + col_right];
				
				// Determine next state based on neighbor count
				case (neighbor_count)
					0, 1: next_q[i * 16 + j] = 0;
					2: next_q[i * 16 + j] = q[i * 16 + j];
					3: next_q[i * 16 + j] = 1;
					4, 5, 6, 7, 8: next_q[i * 16 + j] = 0;
					default: next_q[i * 16 + j] = 0; // Handle unexpected cases, though they shouldn't occur.
				endcase
			end
		end
	end

endmodule