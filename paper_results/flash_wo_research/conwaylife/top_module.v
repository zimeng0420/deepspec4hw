module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    function integer count_neighbors;
        input [255:0] grid;
        input integer row;
        input integer col;
        integer i, j, count;
        begin
            count = 0;
            for (i = -1; i <= 1; i = i + 1) begin
                for (j = -1; j <= 1; j = j + 1) begin
                    if (i == 0 && j == 0) continue;
                    integer neighbor_row = (row + i + 16) % 16;
                    integer neighbor_col = (col + j + 16) % 16;
                    count = count + grid[neighbor_row * 16 + neighbor_col];
                end
            end
            count_neighbors = count;
        end
    endfunction

    reg [255:0] next_q;

    always @(*) begin
        for (integer i = 0; i < 16; i = i + 1) begin
            for (integer j = 0; j < 16; j = j + 1) begin
                integer neighbors = count_neighbors(q, i, j);
                if (q[i * 16 + j]) begin
                    if (neighbors < 2 || neighbors > 3)
                        next_q[i * 16 + j] = 0;
                    else
                        next_q[i * 16 + j] = 1;
                end else begin
                    if (neighbors == 3)
                        next_q[i * 16 + j] = 1;
                    else
                        next_q[i * 16 + j] = 0;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule