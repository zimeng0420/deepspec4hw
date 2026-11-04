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

	always @* begin
		integer i, j;
		for (i = 0; i < 16; i = i + 1) begin
			for (j = 0; j < 16; j = j + 1) begin
				int count = 0;
				// Counting neighbors
				for (int di = -1; di <= 1; di++) begin
					for (int dj = -1; dj <= 1; dj++) begin
						if (di == 0 && dj == 0) continue; // Skip the cell itself
						count = count + q[((i + di + 16) % 16) * 16 + ((j + dj + 16) % 16)];
					end
				end

				// Next state logic
				if (count <= 1) begin
					next_q[(i * 16) + j] = 0;
				end else if (count == 2) begin
					next_q[(i * 16) + j] = q[(i * 16) + j];
				end else if (count == 3) begin
					next_q[(i * 16) + j] = 1;
				end else begin
					next_q[(i * 16) + j] = 0;
				end
			end
		end
	end
endmodule