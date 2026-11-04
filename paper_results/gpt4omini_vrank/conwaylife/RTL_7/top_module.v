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

    integer i;

    function [2:0] count_neighbors;
        input [255:0] state;
        input [3:0] x;
        input [3:0] y;
        integer count;
        begin
            count = 0;
            for (integer dx = -1; dx <= 1; dx = dx + 1) begin
                for (integer dy = -1; dy <= 1; dy = dy + 1) begin
                    if (dx == 0 && dy == 0) continue; // skip the cell itself
                    count = count + state[((x + dx + 16) % 16) * 16 + ((y + dy + 16) % 16)];
                end
            end
            count_neighbors = count;
        end
    endfunction

    always @(*) begin
        next_q = 0;
        for (i = 0; i < 16; i = i + 1) begin
            for (integer j = 0; j < 16; j = j + 1) begin
                case (count_neighbors(q, i, j))
                    0, 1, 4, 5, 6, 7, 8: next_q[(i * 16) + j] = 0; // 0-1 and 4+
                    2: next_q[(i * 16) + j] = q[(i * 16) + j]; // 2 neighbors, state unchanged
                    3: next_q[(i * 16) + j] = 1; // 3 neighbors, cell becomes 1
                    default: next_q[(i * 16) + j] = 0; // any other case
                endcase
            end
        end
    end
endmodule