module top_module(
	input clk,
	input load,
	input [255:0] data,
	output reg [255:0] q
);

	reg [255:0] next_q;
	integer i, j;

	always @(posedge clk) begin
		if (load) begin
			q <= data;
		end else begin
			// Calculate the next state
			for (i = 0; i < 16; i = i + 1) begin
				for (j = 0; j < 16; j = j + 1) begin
					integer neighbor_count;
					neighbor_count = 0;

					// Calculate neighbors
					// Wrap around logic using modulo operator for toroidal grid
					neighbor_count = neighbor_count + q[((i-1+16)%16)*16 + ((j-1+16)%16)];
					neighbor_count = neighbor_count + q[((i-1+16)%16)*16 + ((j+0+16)%16)];
					neighbor_count = neighbor_count + q[((i-1+16)%16)*16 + ((j+1+16)%16)];
					neighbor_count = neighbor_count + q[((i+0+16)%16)*16 + ((j-1+16)%16)];
					neighbor_count = neighbor_count + q[((i+0+16)%16)*16 + ((j+1+16)%16)];
					neighbor_count = neighbor_count + q[((i+1+16)%16)*16 + ((j-1+16)%16)];
					neighbor_count = neighbor_count + q[((i+1+16)%16)*16 + ((j+0+16)%16)];
					neighbor_count = neighbor_count + q[((i+1+16)%16)*16 + ((j+1+16)%16)];


					// Apply the rules of the game
					case (neighbor_count)
						0, 1: next_q[i*16 + j] = 0;
						2: next_q[i*16 + j] = q[i*16 + j];
						3: next_q[i*16 + j] = 1;
						4, 5, 6, 7, 8: next_q[i*16 + j] = 0;
					endcase
				end
			end
			q <= next_q;
		end
	end

endmodule