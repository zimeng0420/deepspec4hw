module top_module(
	input clk,
	input load,
	input [255:0] data,
	output reg [255:0] q);

	wire [3:0] neighbors [15:0][15:0]; // For counting neighbors, 4 bits are enough since max neighbors is 8.

	// Function to count alive neighbors
	function [3:0] count_neighbors;
		input [15:0] x, y;
		begin
			count_neighbors = q[((y+15)%16)*16 + ((x+15)%16)] + q[((y+15)%16)*16 + x] + q[((y+15)%16)*16 + ((x+1)%16)] +
							  q[(y*16)     + ((x+15)%16)] + /*skip self*/ q[(y*16)     + ((x+1)%16)] +
							  q[((y+1)%16)*16 + ((x+15)%16)] + q[((y+1)%16)*16 + x] + q[((y+1)%16)*16 + ((x+1)%16)];
		end
	endfunction

	integer i, j;

	always @(posedge clk) begin
		if (load) begin
			q <= data;
		end
		else begin
			for (j = 0; j < 16; j = j + 1) begin
				for (i = 0; i < 16; i = i + 1) begin
					neighbors[j][i] = count_neighbors(i[3:0], j[3:0]);
					case (neighbors[j][i])
						4'd3: q[j*16 + i] <= 1;
						4'd2: q[j*16 + i] <= q[j*16 + i];
						default: q[j*16 + i] <= 0;
					endcase
				end
			end
		end
	end

endmodule