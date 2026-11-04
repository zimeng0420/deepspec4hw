module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    integer i, j;
    reg [3:0] neighbors; // 4-bit to store neighbor count
    reg [15:0] grid [15:0]; // 16x16 grid representation

    // Load initial state into the grid
    always @(posedge clk) begin
        if (load) begin
            for (i = 0; i < 16; i = i + 1) begin
                grid[i] <= data[i*16 +: 16];
            end
        end else begin
            reg [15:0] next_grid [15:0];
            
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    // Count neighbors
                    neighbors = grid[(i+15)%16][(j+15)%16] + grid[(i+15)%16][j] + grid[(i+15)%16][(j+1)%16] +
                                grid[i][(j+15)%16] + grid[i][(j+1)%16] +
                                grid[(i+1)%16][(j+15)%16] + grid[(i+1)%16][j] + grid[(i+1)%16][(j+1)%16];

                    // Apply game rules
                    if (neighbors == 3) 
                        next_grid[i][j] = 1;
                    else if (neighbors == 2)
                        next_grid[i][j] = grid[i][j];
                    else
                        next_grid[i][j] = 0;
                end
            end

            // Update q with next_grid state
            for (i = 0; i < 16; i = i + 1) begin
                q[i*16 +: 16] <= next_grid[i];
            end
        end
    end
endmodule