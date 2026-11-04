module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    integer x, y, pos, nx, ny, i;
    wire [3:0] neighbors [0:255];

    always @(*) begin
        for (x = 0; x < 16; x = x + 1) begin
            for (y = 0; y < 16; y = y + 1) begin
                pos = x + y*16;
                neighbors[pos] = 0;
                
                // Calculate number of alive neighbors using toroidal indexing
                for (nx = -1; nx <= 1; nx = nx + 1) begin
                    for (ny = -1; ny <= 1; ny = ny + 1) begin
                        if (nx != 0 || ny != 0) begin
                            i = ((x + nx + 16) % 16) + ((y + ny + 16) % 16) * 16;
                            neighbors[pos] = neighbors[pos] + q[i];
                        end
                    end
                end
            end
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (pos = 0; pos < 256; pos = pos + 1) begin
                case (neighbors[pos])
                    4'b0010: q[pos] <= q[pos];       // 2 neighbors: no change
                    4'b0011: q[pos] <= 1;           // 3 neighbors: cell becomes alive
                    default: q[pos] <= 0;           // 0,1 or 4+ neighbors: cell becomes dead
                endcase
            end
        end
    end

endmodule