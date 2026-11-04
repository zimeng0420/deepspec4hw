module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

  reg [255:0] q_next;

  // Combinational logic for calculating the next state
  always @(*) begin
    for (int i = 0; i < 256; i = i + 1) begin
      int row = i / 16;
      int col = i % 16;
      int neighbors = 0;

      // Calculate neighbor indices with toroidal boundary conditions
      int north = ((row - 1 + 16) % 16) * 16 + col;
      int south = ((row + 1) % 16) * 16 + col;
      int east = row * 16 + ((col + 1) % 16);
      int west = row * 16 + ((col - 1 + 16) % 16);
      int north_east = ((row - 1 + 16) % 16) * 16 + ((col + 1) % 16);
      int north_west = ((row - 1 + 16) % 16) * 16 + ((col - 1 + 16) % 16);
      int south_east = ((row + 1) % 16) * 16 + ((col + 1) % 16);
      int south_west = ((row + 1) % 16) * 16 + ((col - 1 + 16) % 16);

      // Count live neighbors
      neighbors = q[north] + q[south] + q[east] + q[west] +
                  q[north_east] + q[north_west] + q[south_east] + q[south_west];

      // Apply Conway's Game of Life rules
      if (q[i] == 1) begin
        if (neighbors < 2) begin
          q_next[i] = 0; // Underpopulation
        end else if (neighbors == 2 || neighbors == 3) begin
          q_next[i] = 1; // Survival
        end else begin
          q_next[i] = 0; // Overpopulation
        end
      end else begin
        if (neighbors == 3) begin
          q_next[i] = 1; // Reproduction
        end else begin
          q_next[i] = 0; // Remains dead
        end
      end
    end
  end

  // Sequential logic for updating the state
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      q <= q_next;
    end
  end

endmodule