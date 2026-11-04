module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q);

    integer x, y, nx, ny;
    reg [3:0] neighbor_count;
    wire [15:0] xpos, ypos;

    // Calculate neighbor positions with toroidal wrap-around
    function [15:0] wrap_index;
        input integer a;
        begin
            if (a < 0)
                wrap_index = a + 16;
            else if (a > 15)
                wrap_index = a - 16;
            else
                wrap_index = a;
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            // Load initial state
            q <= data;
        end 
        else begin
            for (y = 0; y < 16; y = y + 1) begin
                for (x = 0; x < 16; x = x + 1) begin
                    // Initialize neighbor count
                    neighbor_count = 0;

                    // Count live neighbors
                    for (ny = -1; ny <= 1; ny = ny + 1) begin
                        for (nx = -1; nx <= 1; nx = nx + 1) begin
                            if (!(nx == 0 && ny == 0)) begin
                                xpos = wrap_index(x + nx);
                                ypos = wrap_index(y + ny);
                                neighbor_count = neighbor_count + q[ypos*16 + xpos];
                            end
                        end
                    end
                    
                    // Apply the rules of the Game of Life
                    if (neighbor_count == 3 || (neighbor_count == 2 && q[y*16 + x]))
                        q[y*16 + x] <= 1;
                    else
                        q[y*16 + x] <= 0;
                end
            end
        end
    end
endmodule