module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q);

    integer i, j;
    reg [3:0] neighbors; // to hold count of live neighbors for a cell
    reg next_state;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    // Calculate the number of live neighbors
                    neighbors = 0;
                    neighbors = q[((i-1+16)%16)*16 + ((j-1+16)%16)] + q[((i-1+16)%16)*16 + j] + q[((i-1+16)%16)*16 + ((j+1)%16)] +
                                q[i*16 + ((j-1+16)%16)] +                            0 + q[i*16 + ((j+1)%16)] +
                                q[((i+1)%16)*16 + ((j-1+16)%16)] + q[((i+1)%16)*16 + j] + q[((i+1)%16)*16 + ((j+1)%16)];

                    // Determine the next state
                    if (neighbors < 2 || neighbors > 3) 
                        next_state = 0;
                    else if (neighbors == 3) 
                        next_state = 1;
                    else 
                        next_state = q[i*16 + j];  // retain current state

                    // Update cell at position (i, j)
                    q[i*16 + j] <= next_state;
                end
            end
        end
    end
endmodule