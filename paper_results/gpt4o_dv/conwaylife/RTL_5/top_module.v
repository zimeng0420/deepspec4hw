module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q);

    reg [3:0] x, y; // Loop indices
    wire [7:0] neighbors; // To store neighbor count
    reg [255:0] next_q; // For storing next state

    function [7:0] count_neighbors;
        input [8:0] indices;
        reg [3:0] count;
        begin
            count = 0;
            count = count + q[indices[0]] + q[indices[1]] + q[indices[2]] +
                    q[indices[3]] + q[indices[4]] + q[indices[5]] +
                    q[indices[6]] + q[indices[7]];
            count_neighbors = count;
        end
    endfunction

    // Calculate neighbors indices with toroidal wrap-around
    function [8:0] neighbor_indices;
        input [3:0] x, y;
        reg [3:0] xm1, xp1, ym1, yp1; // Wrapped indices
        begin
            xm1 = (x == 4'd0) ? 4'd15 : x - 4'd1;
            xp1 = (x == 4'd15) ? 4'd0 : x + 4'd1;
            ym1 = (y == 4'd0) ? 4'd15 : y - 4'd1;
            yp1 = (y == 4'd15) ? 4'd0 : y + 4'd1;
            neighbor_indices = {xm1 + ym1*16,
                                x   + ym1*16,
                                xp1 + ym1*16,
                                xm1 + y*16,
                                xp1 + y*16,
                                xm1 + yp1*16,
                                x   + yp1*16,
                                xp1 + yp1*16};
        end
    endfunction

    // Process each cell for the next state
    always @(*) begin
        for (x = 0; x < 16; x = x + 1) begin
            for (y = 0; y < 16; y = y + 1) begin
                neighbors = count_neighbors(neighbor_indices(x, y));
                case (neighbors)
                    2: next_q[x + y*16] = q[x + y*16];
                    3: next_q[x + y*16] = 1;
                    default: next_q[x + y*16] = 0;
                endcase
            end
        end
    end

    // Sequential logic for loading and updating the grid
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule