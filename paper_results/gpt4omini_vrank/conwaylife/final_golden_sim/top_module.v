module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    reg [255:0] next_q;

    always @(posedge clk) begin
        if (load) 
            q <= data;
        else 
            q <= next_q;
    end

    integer i, j;
    integer neighbours_count;

    always @(*) begin
        next_q = 256'b0; // Default all cells to dead
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                neighbours_count = 0;

                // Count neighbours using toroidal indexing
                neighbours_count = neighbours_count + q[((i-1+16)%16)*16 + (j-1+16)%16];
                neighbours_count = neighbours_count + q[((i-1+16)%16)*16 + (j+1)%16];
                neighbours_count = neighbours_count + q[((i+1)%16)*16 + (j-1+16)%16];
                neighbours_count = neighbours_count + q[((i+1)%16)*16 + (j+1)%16];
                neighbours_count = neighbours_count + q[(i-1+16)%16*16 + j];
                neighbours_count = neighbours_count + q[(i+1)%16*16 + j];
                neighbours_count = neighbours_count + q[i*16 + (j-1+16)%16];
                neighbours_count = neighbours_count + q[i*16 + (j+1)%16];

                // Determine next state based on the number of neighbours
                case (neighbours_count)
                    0, 1: next_q[i*16 + j] = 0;
                    2: next_q[i*16 + j] = q[i*16 + j]; // stays the same
                    3: next_q[i*16 + j] = 1; // becomes alive
                    default: next_q[i*16 + j] = 0; // 4+ neighbours
                endcase
            end
        end
    end
endmodule