module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q);

    reg [15:0][15:0] grid, next_grid;
    
    integer i, j;
    
    // Function to count the neighbors of a given cell
    function [3:0] count_neighbors;
        input [15:0][15:0] grid;
        input [4:0] x, y;
        integer nx, ny;
        begin
            count_neighbors = 0;
            for(nx = -1; nx <= 1; nx = nx + 1) begin
                for(ny = -1; ny <= 1; ny = ny + 1) begin
                    if(!(nx == 0 && ny == 0)) begin
                        if(grid[(x + nx) & 4'b1111][(y + ny) & 4'b1111] == 1'b1)
                            count_neighbors = count_neighbors + 1;
                    end
                end
            end
        end
    endfunction
    
    // Convert 1D data to 2D grid
    always @(*) begin
        for(i = 0; i < 16; i = i + 1) begin
            for(j = 0; j < 16; j = j + 1) begin
                grid[i][j] = data[i*16 + j];
            end
        end
    end

    // Clock triggering behavior
    always @(posedge clk) begin
        if (load) begin
            // On load, initialize the grid with data
            for(i = 0; i < 16; i = i + 1) begin
                for(j = 0; j < 16; j = j + 1) begin
                    grid[i][j] <= data[i*16 + j];
                end
            end
        end else begin
            // Calculate next state based on current grid state
            for(i = 0; i < 16; i = i + 1) begin
                for(j = 0; j < 16; j = j + 1) begin
                    case (count_neighbors(grid, i, j))
                        4'd2: next_grid[i][j] = grid[i][j]; // Stay the same
                        4'd3: next_grid[i][j] = 1'b1;       // Become alive
                        default: next_grid[i][j] = 1'b0;   // Become dead
                    endcase
                end
            end
            
            // Transfer next_grid to current grid
            for(i = 0; i < 16; i = i + 1) begin
                for(j = 0; j < 16; j = j + 1) begin
                    grid[i][j] <= next_grid[i][j];
                end
            end
        end
        
        // Update output vector q
        for(i = 0; i < 16; i = i + 1) begin
            for(j = 0; j < 16; j = j + 1) begin
                q[i*16 + j] = grid[i][j];
            end
        end
    end

endmodule