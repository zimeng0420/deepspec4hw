module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;
    integer i, j, neighbor_count;
    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Calculate next state based on current state (q)
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    neighbor_count = 0;

                    // Calculate neighbors and count live ones using toroidal boundary conditions
                    if (data[((i-1+16)%16)*16 + ((j-1+16)%16)]) neighbor_count = neighbor_count + 1; // Top-Left
                    if (data[((i-1+16)%16)*16 + j]) neighbor_count = neighbor_count + 1;             // Left
                    if (data[((i-1+16)%16)*16 + ((j+1)%16)]) neighbor_count = neighbor_count + 1;   // Bottom-Left
                    if (data[(i*16) + ((j-1+16)%16)]) neighbor_count = neighbor_count + 1;            // Top
                    if (data[(i*16) + ((j+1)%16)]) neighbor_count = neighbor_count + 1;                // Bottom
                    if (data[((i+1)%16)*16 + ((j-1+16)%16)]) neighbor_count = neighbor_count + 1;  // Top-Right
                    if (data[((i+1)%16)*16 + j]) neighbor_count = neighbor_count + 1;                // Right
                    if (data[((i+1)%16)*16 + ((j+1)%16)]) neighbor_count = neighbor_count + 1;      // Bottom-Right

                    // Apply Game of Life rules
                    if (data[i*16 + j]) begin // Current cell is alive
                        if (neighbor_count < 2) begin
                            next_q[i*16 + j] = 0; // Dies due to underpopulation
                        end else if (neighbor_count == 2 || neighbor_count == 3) begin
                            next_q[i*16 + j] = 1; // Survives
                        end else begin
                            next_q[i*16 + j] = 0; // Dies due to overpopulation
                        end
                    end else begin // Current cell is dead
                        if (neighbor_count == 3) begin
                            next_q[i*16 + j] = 1; // Becomes alive due to reproduction
                        end else begin
                            next_q[i*16 + j] = 0; // Remains dead
                        end
                    end
                end
            end
            q <= next_q;
        end
    end

endmodule