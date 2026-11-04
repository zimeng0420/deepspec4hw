module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [15:0] grid [15:0]; // 16x16 grid
    reg [15:0] next_grid [15:0];
    integer i, j;

    // Helper to count live neighbors considering the grid wraps around (toroid)
    function integer count_neighbors;
        input [15:0] grid_row [15:0];
        input integer x;
        input integer y;
        integer xi, yi, count;
    begin
        count = 0;
        for (xi = -1; xi <= 1; xi = xi + 1) begin
            for (yi = -1; yi <= 1; yi = yi + 1) begin
                if (xi != 0 || yi != 0) begin
                    count = count + grid_row[(x + xi + 16) % 16][(y + yi + 16) % 16];
                end
            end
        end
        count_neighbors = count;
    end
    endfunction

    // On load, initialize the grid; otherwise, update during each clock cycle
    always @(posedge clk) begin
        if (load) begin
            for (i = 0; i < 16; i = i + 1) begin
                grid[i] <= data[i * 16 +: 16];
            end
        end else begin
            // Compute the next state of the grid
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    case (count_neighbors(grid, i, j))
                        2: next_grid[i][j] = grid[i][j]; // State remains the same
                        3: next_grid[i][j] = 1;         // Cell becomes alive
                        default: next_grid[i][j] = 0;   // Cell dies
                    endcase
                end
            end
            
            // Update the grid
            for (i = 0; i < 16; i = i + 1) begin
                grid[i] <= next_grid[i];
            end
        end
    end

    // Output the grid as a flattened vector
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            q[i * 16 +: 16] = grid[i];
        end
    end

endmodule