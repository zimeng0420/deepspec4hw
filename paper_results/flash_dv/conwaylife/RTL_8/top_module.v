module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

  reg [255:0] q_next;

  always @(*) begin
    q_next = 256'b0;
    for (int i = 0; i < 16; i++) begin
      for (int j = 0; j < 16; j++) begin
        int index = i * 16 + j;

        // Calculate neighbor indices with toroidal boundary conditions
        int north = ((i - 1) + 16) % 16;
        int south = (i + 1) % 16;
        int west = ((j - 1) + 16) % 16;
        int east = (j + 1) % 16;
        int northwest = ((i - 1) + 16) % 16;
        int northeast = ((i - 1) + 16) % 16;
        int southwest = (i + 1) % 16;
        int southeast = (i + 1) % 16;

        int northwest_j = ((j - 1) + 16) % 16;
        int northeast_j = (j + 1) % 16;
        int southwest_j = ((j - 1) + 16) % 16;
        int southeast_j = (j + 1) % 16;
        
        // Calculate linear indices for neighbors
        int north_index = north * 16 + j;
        int south_index = south * 16 + j;
        int west_index = i * 16 + west;
        int east_index = i * 16 + east;
        int northwest_index = northwest * 16 + northwest_j;
        int northeast_index = northeast * 16 + northeast_j;
        int southwest_index = southwest * 16 + southwest_j;
        int southeast_index = southeast * 16 + southeast_j;

        // Count live neighbors
        int neighbors = q[north_index] + q[south_index] + q[west_index] + q[east_index] +
                        q[northwest_index] + q[northeast_index] + q[southwest_index] + q[southeast_index];

        // Apply Conway's Game of Life rules
        if (q[index]) begin // Cell is alive
          if (neighbors < 2)
            q_next[index] = 0; // Underpopulation
          else if (neighbors == 2 || neighbors == 3)
            q_next[index] = 1; // Survival
          else
            q_next[index] = 0; // Overpopulation
        end else begin // Cell is dead
          if (neighbors == 3)
            q_next[index] = 1; // Reproduction
          else
            q_next[index] = 0; // Remains dead
        end
      end
    end
  end

  always @(posedge clk) begin
    if (load)
      q <= data;
    else
      q <= q_next;
  end

endmodule