module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

always @(*) begin
    for (int i = 0; i < 256; i = i + 1) begin
        // Calculate row and column indices
        int row = i / 16;
        int col = i % 16;

        // Calculate neighbor indices with wrap-around
        int north = (row == 0) ? 15 : row - 1;
        int south = (row == 15) ? 0 : row + 1;
        int west = (col == 0) ? 15 : col - 1;
        int east = (col == 15) ? 0 : col + 1;

        // Calculate neighbor addresses
        int nw = north * 16 + west;
        int n = north * 16 + col;
        int ne = north * 16 + east;
        int w = row * 16 + west;
        int e = row * 16 + east;
        int sw = south * 16 + west;
        int s = south * 16 + col;
        int se = south * 16 + east;

        // Count live neighbors
        int neighbors = q[nw] + q[n] + q[ne] + q[w] + q[e] + q[sw] + q[s] + q[se];

        // Apply Conway's Game of Life rules
        case (neighbors)
            0, 1: next_q[i] = 0;
            2: next_q[i] = q[i];
            3: next_q[i] = 1;
            default: next_q[i] = 0;
        endcase
    end
end

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule