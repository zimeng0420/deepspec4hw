module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;

    // Count the number of alive neighbors for each cell
    integer i, j, state;
    always @* begin
        next_q = q; // Default to current state
        
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // Determine the index of the current cell
                state = (i * 16) + j;
                
                // Count live neighbors
                integer live_neighbors = 0;
                for (integer di = -1; di <= 1; di = di + 1) begin
                    for (integer dj = -1; dj <= 1; dj = dj + 1) begin
                        if (di == 0 && dj == 0)
                            continue;
                        // Find neighbor indices with wrap-around for toroidal grid
                        integer ni = (i + di + 16) % 16;
                        integer nj = (j + dj + 16) % 16;
                        live_neighbors = live_neighbors + q[(ni * 16) + nj];
                    end
                end
                
                // Apply Game of Life rules
                if (q[state] == 1) begin
                    // Cell is alive
                    if (live_neighbors < 2 || live_neighbors > 3) 
                        next_q[state] = 0; // Dies
                end else begin
                    // Cell is dead
                    if (live_neighbors == 3) 
                        next_q[state] = 1; // Becomes alive
                end
            end
        end
    end

    // Sequential Logic
    always @(posedge clk) begin
        if (load) begin
            q <= data; // Load new state
        end else begin
            q <= next_q; // Update to next state
        end
    end

endmodule