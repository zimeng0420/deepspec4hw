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

    integer i, j, cnt;
    always @(*) begin
        next_q = 0;
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                cnt = 0;
                // Count the number of alive neighbours
                for (integer x = -1; x <= 1; x = x + 1) begin
                    for (integer y = -1; y <= 1; y = y + 1) begin
                        if (x == 0 && y == 0) continue;
                        cnt = cnt + q[{(i + x + 16) % 16, (j + y + 16) % 16}];
                    end
                end
                
                // Apply the rules of the Game of Life
                case (cnt)
                    0, 1: next_q[{i, j}] = 0; // 0-1 neighbours
                    2: next_q[{i, j}] = q[{i, j}]; // 2 neighbours
                    3: next_q[{i, j}] = 1; // 3 neighbours
                    default: next_q[{i, j}] = 0; // 4+ neighbours
                endcase
            end
        end
    end
endmodule