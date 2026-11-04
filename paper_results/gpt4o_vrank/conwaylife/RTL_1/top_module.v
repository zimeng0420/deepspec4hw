module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q);

    reg [15:0] grid [0:15]; // 16x16 grid

    integer i, j;

    // Function to count the living neighbors of a given cell
    function integer count_neighbors;
        input integer x, y;
        integer count, dx, dy, nx, ny;
        begin
            count = 0;
            for (dx = -1; dx <= 1; dx = dx + 1) begin
                for (dy = -1; dy <= 1; dy = dy + 1) begin
                    if (dx != 0 || dy != 0) begin // Exclude the cell itself
                        nx = (x + dx + 16) % 16; // Wrap around using modulo operation
                        ny = (y + dy + 16) % 16;
                        count = count + grid[nx][ny];
                    end
                end
            end
            count_neighbors = count;
        end
    endfunction

    // Assign the input data to the grid
    always @(posedge clk) begin
        if (load) begin
            for (i = 0; i < 16; i = i + 1) begin
                grid[i] <= data[i*16 +: 16];
            end
        end else begin
            reg [15:0] new_grid [0:15]; // Temporary grid for the next state

            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    integer num_neighbors;
                    num_neighbors = count_neighbors(i, j);
                    if (num_neighbors == 3)
                        new_grid[i][j] = 1;
                    else if (num_neighbors == 2)
                        new_grid[i][j] = grid[i][j];
                    else
                        new_grid[i][j] = 0;
                end
            end

            for (i = 0; i < 16; i = i + 1) begin
                grid[i] <= new_grid[i];
            end
        end
    end

    // Output the grid as a 256-bit vector
    always @(posedge clk) begin
        for (i = 0; i < 16; i = i + 1) begin
            q[i*16 +: 16] <= grid[i];
        end
    end

endmodule