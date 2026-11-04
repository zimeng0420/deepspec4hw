module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    reg [255:0] next_q;

    // Neighbor counting and state transition logic
    always @(*) begin
        next_q = q; // Default to current state
        for (int i = 0; i < 256; i++) begin
            int count = 0;
            // Calculate row and column based on index
            int row = i / 16;
            int col = i % 16;

            // Count live neighbors with toroidal wrapping
            for (int r = -1; r <= 1; r++) begin
                for (int c = -1; c <= 1; c++) begin
                    if (r == 0 && c == 0) continue; // Skip self
                    int nbr_row = (row + r + 16) % 16;
                    int nbr_col = (col + c + 16) % 16;
                    count += q[nbr_row * 16 + nbr_col];
                end
            end
            
            // Apply Game of Life rules
            if (count < 2 || count >= 4) 
                next_q[i] = 0; // Becomes dead
            else if (count == 3) 
                next_q[i] = 1; // Becomes alive
            // else remain the same
        end
    end

    // State update logic
    always @(posedge clk) begin
        if (load) 
            q <= data; // Load new state
        else 
            q <= next_q; // Update to next state
    end
endmodule