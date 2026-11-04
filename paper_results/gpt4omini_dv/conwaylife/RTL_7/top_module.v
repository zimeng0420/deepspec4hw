module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;

    integer i, j, neighbor_count;

    always @(*) begin
        next_q = q; // Default to current state
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // Count live neighbors with wrap around for toroidal grid
                neighbor_count = 
                    q[((i-1+16)%16)*16 + (j-1+16)%16] + // Top left
                    q[((i-1+16)%16)*16 + j] +         // Top center
                    q[((i-1+16)%16)*16 + (j+1)%16] + // Top right
                    q[(i*16 + (j-1+16)%16)] +         // Middle left
                    q[(i*16 + (j+1)%16)] +             // Middle right
                    q[((i+1)%16)*16 + (j-1+16)%16] + // Bottom left
                    q[((i+1)%16)*16 + j] +            // Bottom center
                    q[((i+1)%16)*16 + (j+1)%16];      // Bottom right

                // State transition logic
                case (neighbor_count)
                    0, 1: next_q[i*16 + j] = 0;   // 0-1 neighbors -> dead
                    2: next_q[i*16 + j] = q[i*16 + j]; // 2 neighbors -> state unchanged
                    3: next_q[i*16 + j] = 1;      // 3 neighbors -> alive
                    default: next_q[i*16 + j] = 0; // 4+ neighbors -> dead
                endcase
            end
        end
    end

    always @(posedge clk) begin
        if (load) 
            q <= data; // Load initial state
        else 
            q <= next_q; // Update state
    end

endmodule