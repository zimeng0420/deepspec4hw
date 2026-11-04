module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;

    // Function to calculate the number of live neighbors for a given cell
    function integer count_neighbors;
        input integer row, col;
        integer count, r, c;
        begin
            count = 0;
            for (integer i = -1; i <= 1; i = i + 1) begin
                for (integer j = -1; j <= 1; j = j + 1) begin
                    if (i == 0 && j == 0) continue; // Skip the cell itself

                    r = row + i;
                    c = col + j;

                    // Toroidal boundary conditions
                    if (r < 0) r = r + 16;
                    if (r > 15) r = r - 16;
                    if (c < 0) c = c + 16;
                    if (c > 15) c = c - 16;

                    count = count + q[r * 16 + c];
                end
            end
            count_neighbors = count;
        end
    endfunction

    // Combinational logic to calculate the next state of each cell
    always @(*) begin
        for (integer i = 0; i < 16; i = i + 1) begin
            for (integer j = 0; j < 16; j = j + 1) begin
                integer neighbors = count_neighbors(i, j);
                case (neighbors)
                    0, 1: next_q[i * 16 + j] = 0;
                    2: next_q[i * 16 + j] = q[i * 16 + j];
                    3: next_q[i * 16 + j] = 1;
                    default: next_q[i * 16 + j] = 0;
                endcase
            end
        end
    end

    // Sequential logic to update the grid
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule