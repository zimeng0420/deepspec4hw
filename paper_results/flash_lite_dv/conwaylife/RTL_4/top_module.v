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
            for (i = 0; i < 256; i = i + 1) begin
                row = i / 16;
                col = i % 16;
                neighbor_count = 0;

                // Count neighbors
                neighbor_count = neighbor_count + data[((row-1+16)%16)*16 + (col-1+16)%16]; // Top-Left
                neighbor_count = neighbor_count + data[((row-1+16)%16)*16 + col];           // Left
                neighbor_count = neighbor_count + data[((row-1+16)%16)*16 + (col+1)%16];   // Bottom-Left
                neighbor_count = neighbor_count + data[(row*16) + (col-1+16)%16];           // Top
                neighbor_count = neighbor_count + data[(row*16) + (col+1)%16];              // Bottom
                neighbor_count = neighbor_count + data[((row+1)%16)*16 + (col-1+16)%16];   // Top-Right
                neighbor_count = neighbor_count + data[((row+1)%16)*16 + col];             // Right
                neighbor_count = neighbor_count + data[((row+1)%16)*16 + (col+1)%16];     // Bottom-Right
                
                // Apply Game of Life rules
                if (data[i] == 1) begin // Cell is alive
                    if (neighbor_count < 2) begin
                        next_q[i] = 0; // Dies of underpopulation
                    end else if (neighbor_count == 2 || neighbor_count == 3) begin
                        next_q[i] = 1; // Lives on
                    end else begin
                        next_q[i] = 0; // Dies of overpopulation
                    end
                end else begin // Cell is dead
                    if (neighbor_count == 3) begin
                        next_q[i] = 1; // Becomes alive
                    end else begin
                        next_q[i] = 0; // Remains dead
                    end
                end
            end
            q <= next_q;
        end
    end
    
endmodule