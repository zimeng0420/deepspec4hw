module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q);

    reg [15:0] grid [15:0];
    reg [15:0] new_grid [15:0];

    integer i, j;

    // Function to calculate neighbors
    function [3:0] count_neighbors;
        input integer x, y;
        integer x_offset, y_offset;
        begin
            count_neighbors = 4'd0;
            for (x_offset = -1; x_offset <= 1; x_offset = x_offset + 1) begin
                for (y_offset = -1; y_offset <= 1; y_offset = y_offset + 1) begin
                    if (x_offset != 0 || y_offset != 0) begin
                        count_neighbors = count_neighbors + grid[(x + x_offset + 16) % 16][(y + y_offset + 16) % 16];
                    end
                end
            end
        end
    endfunction

    // Load initial state or update state
    always @(posedge clk) begin
        if (load) begin
            for (i = 0; i < 16; i = i + 1) begin
                grid[i] = data[i*16 +: 16];
            end
        end else begin
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    case (count_neighbors(i, j))
                        1, 4, 5, 6, 7, 8: new_grid[i][j] = 1'b0; // Fewer than 2 or more than 3 neighbors
                        3: new_grid[i][j] = 1'b1; // Exactly 3 neighbors
                        2: new_grid[i][j] = grid[i][j]; // Exactly 2 neighbors: remains the same
                        default: new_grid[i][j] = 1'b0; // Default case
                    endcase
                end
            end
            for (i = 0; i < 16; i = i + 1) begin
                grid[i] = new_grid[i];
            end
            for (i = 0; i < 16; i = i + 1) begin
                q[i*16 +: 16] = grid[i];
            end
        end
    end
endmodule