module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

  reg [255:0] next_q;
  integer i, row, col, neighbor_count;
  reg [7:0] neighbor_indices [0:7];
  
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
        
      for (i = 0; i < 256; i = i + 1) begin
        row = i / 16;
        col = i % 16;

        // Calculate neighbor indices - toroidal
        neighbor_indices[0] = ( (row - 1 + 16) % 16) * 16 + ((col - 1 + 16) % 16); // Top-Left
        neighbor_indices[1] = ( (row - 1 + 16) % 16) * 16 + col;                // Top
        neighbor_indices[2] = ( (row - 1 + 16) % 16) * 16 + ((col + 1) % 16);   // Top-Right
        neighbor_indices[3] = row * 16 + ((col - 1 + 16) % 16);                  // Left
        neighbor_indices[4] = row * 16 + ((col + 1) % 16);                      // Right
        neighbor_indices[5] = ( (row + 1) % 16) * 16 + ((col - 1 + 16) % 16);   // Bottom-Left
        neighbor_indices[6] = ( (row + 1) % 16) * 16 + col;                // Bottom
        neighbor_indices[7] = ( (row + 1) % 16) * 16 + ((col + 1) % 16);   // Bottom-Right

        // Count live neighbors
        neighbor_count = 0;
        for (integer j = 0; j < 8; j = j + 1) begin
          neighbor_count = neighbor_count + data[neighbor_indices[j]];
        end

        // Apply Game of Life rules
        if (data[i]) begin // Cell is alive
          if (neighbor_count < 2) begin
            next_q[i] = 0;
          end else if (neighbor_count > 3) begin
            next_q[i] = 0;
          end else begin
            next_q[i] = 1;
          end
        end else begin // Cell is dead
          if (neighbor_count == 3) begin
            next_q[i] = 1;
          end else begin
            next_q[i] = 0;
          end
        end
      end
      q <= next_q;
    end
  end

endmodule