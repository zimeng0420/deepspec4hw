module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    integer i, x, y;
    reg [3:0] num_neighbors;
    wire [255:0] next_state;
    
    // Compute the next state for each cell
    always @(*) begin
        for (i = 0; i < 256; i = i + 1) begin
            x = i % 16;
            y = i / 16;

            // Calculate the number of alive neighbors
            num_neighbors = q[((x-1+16)%16) + ((y-1+16)%16)*16] + // Top-left
                            q[x + ((y-1+16)%16)*16] +            // Top
                            q[((x+1)%16) + ((y-1+16)%16)*16] +   // Top-right
                            q[((x-1+16)%16) + y*16] +            // Left
                            q[((x+1)%16) + y*16] +               // Right
                            q[((x-1+16)%16) + ((y+1)%16)*16] +   // Bottom-left
                            q[x + ((y+1)%16)*16] +               // Bottom
                            q[((x+1)%16) + ((y+1)%16)*16];       // Bottom-right

            // Determine the next state based on Game of Life rules
            case (num_neighbors)
                2: next_state[i] = q[i]; // Stay the same
                3: next_state[i] = 1;    // Become alive
                default: next_state[i] = 0; // Become dead
            endcase
        end
    end

    // Update the state on clock edge
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule