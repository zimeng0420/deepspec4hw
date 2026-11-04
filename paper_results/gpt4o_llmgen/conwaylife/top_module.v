module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [15:0] grid[15:0];  // 16x16 grid, each cell is 1 bit in width
    reg [15:0] next_grid[15:0]; 

    integer i, j, ni, nj, neighbours_count;

    // Convert linear data input to 2D grid representation
    always @(posedge clk) begin
        if (load) begin
            for (i = 0; i < 16; i = i + 1) begin
                grid[i] <= data[i*16 +: 16];  // Slicing 16 bits at a time
            end
        end else begin
            // Update grid based on neighbor calculations
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    // Calculate number of live neighbours
                    neighbours_count = 0;
                    for (ni = -1; ni <= 1; ni = ni + 1) begin
                        for (nj = -1; nj <= 1; nj = nj + 1) begin
                            if (ni != 0 || nj != 0) begin
                                neighbours_count = neighbours_count +
                                    grid[(i+ni+16) % 16][(j+nj+16) % 16];
                            end
                        end
                    end

                    // Determine next state based on the Game of Life rules
                    case (neighbours_count)
                        2: next_grid[i][j] = grid[i][j];  // State does not change
                        3: next_grid[i][j] = 1;           // Cell becomes alive
                        default: next_grid[i][j] = 0;     // Cell becomes dead
                    endcase
                end
            end

            // Update current grid with next state
            for (i = 0; i < 16; i = i + 1) begin
                grid[i] <= next_grid[i];
            end
        end

        // Convert 2D grid representation back to linear output
        for (i = 0; i < 16; i = i + 1) begin
            q[i*16 +: 16] <= grid[i];
        end
    end
endmodule