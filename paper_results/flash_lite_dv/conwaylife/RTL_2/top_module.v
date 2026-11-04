module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;
    integer i, row, col, neighbor_count;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Calculate next state
            for (i = 0; i < 256; i = i + 1) begin
                row = i / 16;
                col = i % 16;
                neighbor_count = 0;

                // Count live neighbors (toroidal)
                neighbor_count = neighbor_count + data[((row - 1 + 16) % 16) * 16 + ((col - 1 + 16) % 16)]; // Top-Left
                neighbor_count = neighbor_count + data[((row - 1 + 16) % 16) * 16 + col];               // Top
                neighbor_count = neighbor_count + data[((row - 1 + 16) % 16) * 16 + ((col + 1) % 16)];   // Top-Right
                neighbor_count = neighbor_count + data[row * 16 + ((col - 1 + 16) % 16)];               // Left
                neighbor_count = neighbor_count + data[row * 16 + ((col + 1) % 16)];                   // Right
                neighbor_count = neighbor_count + data[((row + 1) % 16) * 16 + ((col - 1 + 16) % 16)];   // Bottom-Left
                neighbor_count = neighbor_count + data[((row + 1) % 16) * 16 + col];                     // Bottom
                neighbor_count = neighbor_count + data[((row + 1) % 16) * 16 + ((col + 1) % 16)];       // Bottom-Right


                // Apply Game of Life rules
                if (data[i]) begin // Cell is alive
                    if (neighbor_count < 2)
                        next_q[i] = 0; // Dies (underpopulation)
                    else if (neighbor_count > 3)
                        next_q[i] = 0; // Dies (overpopulation)
                    else
                        next_q[i] = 1; // Lives
                end else begin // Cell is dead
                    if (neighbor_count == 3)
                        next_q[i] = 1; // Becomes alive (reproduction)
                    else
                        next_q[i] = 0; // Remains dead
                end
            end
            q <= next_q;

        end
    end
endmodule