module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    reg [255:0] next_q;
    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

    integer i, j;
    always @* begin
        next_q = q; // initialize next state
        
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                int live_neighbors = 0;
                for (int x = -1; x <= 1; x = x + 1) begin
                    for (int y = -1; y <= 1; y = y + 1) begin
                        if (x == 0 && y == 0) continue; // skip the cell itself
                        int ni = (i + x + 16) % 16; // wrap around vertically
                        int nj = (j + y + 16) % 16; // wrap around horizontally
                        live_neighbors = live_neighbors + q[ni * 16 + nj];
                    end
                end

                case (live_neighbors)
                    1: next_q[i * 16 + j] = 0; // 0-1 neighbors
                    2: next_q[i * 16 + j] = q[i * 16 + j]; // 2 neighbors, state unchanged
                    3: next_q[i * 16 + j] = 1; // 3 neighbors
                    default: next_q[i * 16 + j] = 0; // 4 or more neighbors
                endcase
            end
        end
    end
endmodule