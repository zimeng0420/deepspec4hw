module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    reg [255:0] next_q;

    integer i, j;
    always @(*) begin
        next_q = q; // Default to current state
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // Count the number of live neighbors
                integer neighbors;
                neighbors = q[(i*16 + (j-1+16)%16)] + q[(i*16 + (j+1)%16)] + 
                            q[(((i-1+16)%16)*16) + j] + q[(((i+1)%16)*16) + j] + 
                            q[(((i-1+16)%16)*16) + (j-1+16)%16] + q[(((i-1+16)%16)*16) + (j+1)%16] + 
                            q[(((i+1)%16)*16) + (j-1+16)%16] + q[(((i+1)%16)*16) + (j+1)%16];

                // Apply Game of Life rules
                if (q[i*16 + j] == 1) begin
                    if (neighbors < 2 || neighbors > 3) 
                        next_q[i*16 + j] = 0; // Dies
                end else begin
                    if (neighbors == 3) 
                        next_q[i*16 + j] = 1; // Comes to life
                end
            end
        end
    end

    always @(posedge clk) begin
        if (load) 
            q <= data; // Load new state
        else 
            q <= next_q; // Update to the next state
    end
endmodule