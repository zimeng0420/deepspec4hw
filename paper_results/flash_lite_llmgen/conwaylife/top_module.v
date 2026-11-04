module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Internal signals
    reg [255:0] next_q;  // Next state of the grid
    integer i, j;       // Loop indices

    // Load data on load signal
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end
    end

    // Main game logic
    always @(posedge clk) begin
        // Iterate through each cell in the grid
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // Calculate the index of the current cell
                integer current_index = i * 16 + j;

                // Calculate neighbor indices using modular arithmetic for toroidal wrapping
                integer neighbor_count = 0;
                integer row, col;

                // Iterate through the 8 neighbors
                for (integer row_offset = -1; row_offset <= 1; row_offset = row_offset + 1) begin
                    for (integer col_offset = -1; col_offset <= 1; col_offset = col_offset + 1) begin
                        // Skip the current cell itself
                        if (row_offset == 0 && col_offset == 0) begin
                            continue;
                        end

                        // Calculate neighbor row and column indices
                        row = i + row_offset;
                        col = j + col_offset;

                        // Apply toroidal wrapping
                        row = (row + 16) % 16; // Ensure positive modulo
                        col = (col + 16) % 16;

                        // Calculate the neighbor's index
                        integer neighbor_index = row * 16 + col;

                        // Count the live neighbors
                        neighbor_count = neighbor_count + q[neighbor_index];
                    end
                end

                // Apply Game of Life rules
                if (q[current_index] == 1) begin // Current cell is alive
                    if (neighbor_count < 2) begin
                        next_q[current_index] = 0; // Dies from underpopulation
                    end else if (neighbor_count == 2 || neighbor_count == 3) begin
                        next_q[current_index] = 1; // Survives
                    end else begin
                        next_q[current_index] = 0; // Dies from overpopulation
                    end
                end else begin // Current cell is dead
                    if (neighbor_count == 3) begin
                        next_q[current_index] = 1; // Becomes alive from reproduction
                    end else begin
                        next_q[current_index] = 0; // Remains dead
                    end
                end
            end
        end
        q <= next_q; // Update the grid state
    end

endmodule