module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

  // Internal signals
  reg [255:0] next_q;
  wire [7:0] neighbor_count [255:0];

  // Calculate neighbor count for each cell
  genvar i;
  generate
    for (i = 0; i < 256; i = i + 1) begin : cell_logic
      integer row, col;
      assign row = i / 16;
      assign col = i % 16;

      wire [7:0] neighbors;

      assign neighbors[0] = data[((row-1+16)%16)*16 + ((col-1+16)%16)]; // Top-Left
      assign neighbors[1] = data[((row-1+16)%16)*16 + col];             // Top
      assign neighbors[2] = data[((row-1+16)%16)*16 + ((col+1)%16)];     // Top-Right
      assign neighbors[3] = data[row*16 + ((col-1+16)%16)];             // Left
      assign neighbors[4] = data[row*16 + ((col+1)%16)];                 // Right
      assign neighbors[5] = data[((row+1)%16)*16 + ((col-1+16)%16)];     // Bottom-Left
      assign neighbors[6] = data[((row+1)%16)*16 + col];                 // Bottom
      assign neighbors[7] = data[((row+1)%16)*16 + ((col+1)%16)];         // Bottom-Right

      assign neighbor_count[i] = neighbors[0] + neighbors[1] + neighbors[2] + neighbors[3] + neighbors[4] + neighbors[5] + neighbors[6] + neighbors[7];

    end
  endgenerate

  // Determine next state for each cell based on Game of Life rules
  always @(*) begin
    integer j;
    for (j = 0; j < 256; j = j + 1) begin
      if (data[j] == 1) begin // Cell is alive
        case (neighbor_count[j])
          0, 1: next_q[j] = 0;  // Dies due to underpopulation
          2, 3: next_q[j] = 1;  // Lives on
          default: next_q[j] = 0; // Dies due to overpopulation
        endcase
      end else begin // Cell is dead
        if (neighbor_count[j] == 3) begin
          next_q[j] = 1;  // Becomes alive due to reproduction
        end else begin
          next_q[j] = 0;  // Remains dead
        end
      end
    end
  end

  // Synchronous update of q
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      q <= next_q;
    end
  end

endmodule