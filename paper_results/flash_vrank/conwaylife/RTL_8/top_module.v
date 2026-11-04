module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

    always @(*) begin
        for (int i = 0; i < 256; i++) begin
            int row = i / 16;
            int col = i % 16;

            // Calculate neighbor indices with wraparound
            int north = (row == 0) ? 15 : row - 1;
            int south = (row == 15) ? 0 : row + 1;
            int west = (col == 0) ? 15 : col - 1;
            int east = (col == 15) ? 0 : col + 1;

            // Calculate neighbor sum
            int neighbor_sum = 
                q[north * 16 + west] +
                q[north * 16 + col] +
                q[north * 16 + east] +
                q[row * 16 + west] +
                q[row * 16 + east] +
                q[south * 16 + west] +
                q[south * 16 + col] +
                q[south * 16 + east];

            // Apply Conway's Game of Life rules
            case (neighbor_sum)
                0, 1: next_q[i] = 0;
                2: next_q[i] = q[i];
                3: next_q[i] = 1;
                default: next_q[i] = 0;
            endcase
        end
    end

endmodule