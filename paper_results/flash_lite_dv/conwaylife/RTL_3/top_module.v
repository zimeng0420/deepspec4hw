module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Internal signals
    reg [255:0] next_q;
    integer i, j;
    reg [7:0] neighbor_count;
    reg current_cell_state;
    reg next_cell_state;
    
    // Calculate next state of each cell
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // Calculate cell index
                integer cell_index = i * 16 + j;
                
                // Get current cell state
                current_cell_state = data[cell_index];
                
                // Calculate neighbor count
                neighbor_count = 0;

                // Top-Left
                if (data[((i-1+16)%16)*16 + ((j-1+16)%16)]) neighbor_count = neighbor_count + 1;
                // Left
                if (data[((i-1+16)%16)*16 + j]) neighbor_count = neighbor_count + 1;
                // Bottom-Left
                if (data[((i-1+16)%16)*16 + ((j+1)%16)]) neighbor_count = neighbor_count + 1;
                // Top
                if (data[i*16 + ((j-1+16)%16)]) neighbor_count = neighbor_count + 1;
                // Bottom
                if (data[i*16 + ((j+1)%16)]) neighbor_count = neighbor_count + 1;
                // Top-Right
                if (data[((i+1)%16)*16 + ((j-1+16)%16)]) neighbor_count = neighbor_count + 1;
                // Right
                if (data[((i+1)%16)*16 + j]) neighbor_count = neighbor_count + 1;
                // Bottom-Right
                if (data[((i+1)%16)*16 + ((j+1)%16)]) neighbor_count = neighbor_count + 1;


                // Apply Game of Life rules
                if (current_cell_state) begin
                    // Live cell
                    if (neighbor_count < 2) begin
                        next_cell_state = 0;
                    end else if (neighbor_count == 2 || neighbor_count == 3) begin
                        next_cell_state = 1;
                    end else begin
                        next_cell_state = 0;
                    end
                end else begin
                    // Dead cell
                    if (neighbor_count == 3) begin
                        next_cell_state = 1;
                    end else begin
                        next_cell_state = 0;
                    end
                end

                // Assign next state to next_q
                next_q[cell_index] = next_cell_state;
            end
        end
    end

    // Update q on clock edge
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule