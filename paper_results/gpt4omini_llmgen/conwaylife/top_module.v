module top_module(
    input clk,                  // Clock signal for synchronizing state updates
    input load,                 // Active high signal to load initial state
    input [255:0] data,         // 256-bit input data representing the initial state of the 16x16 grid
    output reg [255:0] q        // 256-bit output representing the current state of the grid
);

// Internal Registers
reg [255:0] next_q;            // Register for next state storage
integer i, j;                  // Loop variables for neighbor counting
integer neighbor_count;        // Count of alive neighbors for each cell

// Process for loading initial state
always @(posedge clk) begin
    if (load) begin
        q <= data;              // Load initial state into q
    end else begin
        q <= next_q;           // Update q to the next state at every clock cycle
    end
end

// Process for computing the next state of the grid
always @(*) begin
    next_q = q;                 // Initialize next_q to current state
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            neighbor_count = 0; // Reset neighbor count for each cell

            // Count alive neighbors considering toroidal wrapping
            for (integer m = -1; m <= 1; m++) begin
                for (integer n = -1; n <= 1; n++) begin
                    if (m == 0 && n == 0) continue; // Skip the cell itself
                    neighbor_count = neighbor_count + q[( (i + m + 16) % 16 ) * 16 + ( (j + n + 16) % 16 )];
                end
            end

            // Determine the cell's next state based on neighbor count
            case (neighbor_count)
                0, 1, 4: next_q[i * 16 + j] = 0;    // 0-1 or 4+ neighbors: dead
                2: next_q[i * 16 + j] = q[i * 16 + j]; // 2 neighbors: state unchanged
                3: next_q[i * 16 + j] = 1;          // 3 neighbors: alive
            endcase
        end
    end
end

endmodule