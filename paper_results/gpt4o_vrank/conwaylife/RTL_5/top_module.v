module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q);

    reg [15:0] grid [15:0];
    integer i, j;
    
    always @(posedge clk) begin
        if (load) begin
            for (i = 0; i < 16; i = i + 1) begin
                grid[i] <= data[i*16 +: 16];
            end
            q <= data;
        end else begin
            reg [15:0] next_grid [15:0];
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    integer count;
                    count = 0;
                    // Calculate number of alive neighbors (including wrap-around)
                    count = grid[(i+15)%16][(j+15)%16] + grid[(i+15)%16][j] + grid[(i+15)%16][(j+1)%16] +
                            grid[i][(j+15)%16]                   + grid[i][(j+1)%16] +
                            grid[(i+1)%16][(j+15)%16] + grid[(i+1)%16][j] + grid[(i+1)%16][(j+1)%16];
                    
                    // Apply the rules of the game
                    case(count)
                        2: next_grid[i][j] = grid[i][j]; // State remains the same
                        3: next_grid[i][j] = 1;           // Becomes alive
                        default: next_grid[i][j] = 0;    // Becomes dead
                    endcase
                end
            end
            for (i = 0; i < 16; i = i + 1) begin
                grid[i] <= next_grid[i];
                q[i*16 +: 16] <= next_grid[i];
            end
        end
    end
    
endmodule