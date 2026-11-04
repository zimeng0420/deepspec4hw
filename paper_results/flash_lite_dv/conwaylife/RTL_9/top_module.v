module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

  reg [255:0] next_q;
  integer i, j, neighbor_count;
  
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                neighbor_count = 0;

                // Calculate neighbors' indices and count live neighbors
                neighbor_count = neighbor_count + data[((i-1+16)%16)*16 + ((j-1+16)%16)]; // Top-Left
                neighbor_count = neighbor_count + data[((i-1+16)%16)*16 + j];           // Left
                neighbor_count = neighbor_count + data[((i-1+16)%16)*16 + ((j+1)%16)];   // Bottom-Left
                neighbor_count = neighbor_count + data[(i)*16 + ((j-1+16)%16)];           // Top
                neighbor_count = neighbor_count + data[(i)*16 + ((j+1)%16)];               // Bottom
                neighbor_count = neighbor_count + data[((i+1)%16)*16 + ((j-1+16)%16)];   // Top-Right
                neighbor_count = neighbor_count + data[((i+1)%16)*16 + j];           // Right
                neighbor_count = neighbor_count + data[((i+1)%16)*16 + ((j+1)%16)];       // Bottom-Right

                // Apply Game of Life rules
                if (data[i*16 + j] == 1) begin // Current cell is alive
                    if (neighbor_count < 2) begin
                        next_q[i*16 + j] <= 0; // Dies (underpopulation)
                    end else if (neighbor_count > 3) begin
                        next_q[i*16 + j] <= 0; // Dies (overpopulation)
                    end else begin
                        next_q[i*16 + j] <= 1; // Lives on
                    end
                end else begin // Current cell is dead
                    if (neighbor_count == 3) begin
                        next_q[i*16 + j] <= 1; // Becomes alive (reproduction)
                    end else begin
                        next_q[i*16 + j] <= 0; // Remains dead
                    end
                end
            end
        end
        q <= next_q;
    end
  end

endmodule