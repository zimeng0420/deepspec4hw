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
        integer i, row, col, neighbors;
        for (i = 0; i < 256; i = i + 1) begin
            row = i / 16;
            col = i % 16;

            neighbors = 0;

            // Calculate neighbors with toroidal boundary conditions
            neighbors = neighbors + q[((row + 1) % 16) * 16 + ((col + 1) % 16)];
            neighbors = neighbors + q[((row + 1) % 16) * 16 + (col % 16)];
            neighbors = neighbors + q[((row + 1) % 16) * 16 + ((col - 1 + 16) % 16)];
            neighbors = neighbors + q[(row % 16) * 16 + ((col + 1) % 16)];
            neighbors = neighbors + q[(row % 16) * 16 + ((col - 1 + 16) % 16)];
            neighbors = neighbors + q[((row - 1 + 16) % 16) * 16 + ((col + 1) % 16)];
            neighbors = neighbors + q[((row - 1 + 16) % 16) * 16 + (col % 16)];
            neighbors = neighbors + q[((row - 1 + 16) % 16) * 16 + ((col - 1 + 16) % 16)];

            // Apply Conway's Game of Life rules
            if (neighbors < 2 || neighbors > 3) begin
                next_q[i] = 0;
            end else if (neighbors == 2) begin
                next_q[i] = q[i];
            end else if (neighbors == 3) begin
                next_q[i] = 1;
            end
        end
    end

endmodule