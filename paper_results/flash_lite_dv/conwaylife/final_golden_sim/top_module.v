module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

  reg [255:0] next_q;
  integer i, row, col, neighbor_count;

  always @(*) begin
    // Default next state is the current state
    next_q = q;

    // Iterate through each cell in the grid
    for (i = 0; i < 256; i = i + 1) begin
      row = i / 16;
      col = i % 16;
      neighbor_count = 0;

      // Count live neighbors using toroidal boundary conditions
      neighbor_count =
      data[((row - 1 + 16) % 16) * 16 + ((col - 1 + 16) % 16)] + // Top-Left
      data[((row - 1 + 16) % 16) * 16 + col] +                     // Top
      data[((row - 1 + 16) % 16) * 16 + ((col + 1) % 16)] +      // Top-Right
      data[(row * 16) + ((col - 1 + 16) % 16)] +                 // Left
      data[(row * 16) + ((col + 1) % 16)] +                     // Right
      data[((row + 1) % 16) * 16 + ((col - 1 + 16) % 16)] +      // Bottom-Left
      data[((row + 1) % 16) * 16 + col] +                         // Bottom
      data[((row + 1) % 16) * 16 + ((col + 1) % 16)];            // Bottom-Right

      // Apply Game of Life rules
      if (data[i]) begin // Cell is alive
        if (neighbor_count < 2) begin
          next_q[i] = 0; // Dies due to underpopulation
        end else if (neighbor_count > 3) begin
          next_q[i] = 0; // Dies due to overpopulation
        end else begin
          next_q[i] = 1; // Survives
        end
      end else begin // Cell is dead
        if (neighbor_count == 3) begin
          next_q[i] = 1; // Becomes alive due to reproduction
        end else begin
          next_q[i] = 0; // Remains dead
        end
      end
    end
  end


  always @(posedge clk) begin
    if (load) begin
      q <= data; // Load initial state
    end else begin
      q <= next_q; // Update game state
    end
  end

endmodule