module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q);

    wire [3:0] neighbor_count [255:0]; // To store the neighbor count for each cell

    always @(*) begin
        integer x, y;
        for (x = 0; x < 16; x = x + 1) begin
            for (y = 0; y < 16; y = y + 1) begin
                integer sum;
                integer nx, ny;

                // Calculate the sum of the neighbors
                sum = 0;
                for (nx = -1; nx <= 1; nx = nx + 1) begin
                    for (ny = -1; ny <= 1; ny = ny + 1) begin
                        if (nx != 0 || ny != 0) begin // Exclude the cell itself
                            sum = sum + q[((x+nx+16)%16) + ((y+ny+16)%16)*16];
                        end
                    end
                end
                
                neighbor_count[x + y*16] = sum[3:0]; // Store the sum in the neighbor count
            end
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end
        else begin
            integer i;
            for (i = 0; i < 256; i = i + 1) begin
                case (neighbor_count[i])
                    4'b0000, 4'b0001, 4'b0100, 4'b0101, 4'b0110, 4'b0111, 4'b1000: q[i] <= 1'b0; // 0, 1, 4+ neighbors
                    4'b0010: q[i] <= q[i]; // 2 neighbors: retain current state
                    4'b0011: q[i] <= 1'b1; // 3 neighbors: alive
                    default: q[i] <= 1'b0;
                endcase
            end
        end
    end

endmodule