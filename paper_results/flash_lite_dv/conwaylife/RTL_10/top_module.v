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
            // Calculate the next state based on the current state (q)
            for (i = 0; i < 256; i = i + 1) begin
                row = i / 16;
                col = i % 16;
                neighbor_count = 0;

                // Calculate neighbors and count live cells
                neighbor_count = 
                    data[((row-1+16)%16)*16 + (col-1+16)%16] +  // Top-Left
                    data[((row-1+16)%16)*16 + col] +           // Left
                    data[((row-1+16)%16)*16 + (col+1)%16] +    // Bottom-Left
                    data[row*16 + (col-1+16)%16] +            // Top
                    data[row*16 + (col+1)%16] +                // Bottom
                    data[((row+1)%16)*16 + (col-1+16)%16] +    // Top-Right
                    data[((row+1)%16)*16 + col] +             // Right
                    data[((row+1)%16)*16 + (col+1)%16];        // Bottom-Right
                
                // Apply Game of Life rules
                if (data[i]) begin // Cell is alive
                    if (neighbor_count < 2) begin
                        next_q[i] = 0;
                    end else if (neighbor_count > 3) begin
                        next_q[i] = 0;
                    end else begin
                        next_q[i] = 1;
                    end
                end else begin // Cell is dead
                    if (neighbor_count == 3) begin
                        next_q[i] = 1;
                    end else begin
                        next_q[i] = 0;
                    end
                end
            end
            q <= next_q;
        end
    end

endmodule