module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [3:0] neighbor_count;
    integer x, y, i, j, index;

    // Function to count alive neighbors for cell at (x, y)
    function [3:0] count_neighbors;
        input [255:0] q;
        input integer x, y;
        integer dx, dy, nx, ny;
        begin
            count_neighbors = 0;
            for (dx = -1; dx <= 1; dx = dx + 1) begin
                for (dy = -1; dy <= 1; dy = dy + 1) begin
                    if (!(dx == 0 && dy == 0)) begin
                        nx = (x + dx + 16) % 16; // Wrap around horizontally
                        ny = (y + dy + 16) % 16; // Wrap around vertically
                        index = nx + ny*16;
                        count_neighbors = count_neighbors + q[index];
                    end
                end
            end
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (x = 0; x < 16; x = x + 1) begin
                for (y = 0; y < 16; y = y + 1) begin
                    index = x + y*16;
                    neighbor_count = count_neighbors(q, x, y);
                    
                    case (neighbor_count)
                        4'd2: q[index] <= q[index]; // Keep the same state
                        4'd3: q[index] <= 1; // Becomes alive
                        default: q[index] <= 0; // Becomes dead
                    endcase
                end
            end
        end
    end
endmodule