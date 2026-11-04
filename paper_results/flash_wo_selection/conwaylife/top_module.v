module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;

    always @(*) begin
        next_q = 0; // Initialize next_q to avoid latches
        for (int i = 0; i < 256; i = i + 1) begin
            integer row, col, n, s, e, w, ne, nw, se, sw, neighbors;

            row = i / 16;
            col = i % 16;

            n  = ((row - 1 + 16) % 16) * 16 + col;
            s  = ((row + 1 + 16) % 16) * 16 + col;
            e  = row * 16 + ((col + 1 + 16) % 16);
            w  = row * 16 + ((col - 1 + 16) % 16);
            ne = ((row - 1 + 16) % 16) * 16 + ((col + 1 + 16) % 16);
            nw = ((row - 1 + 16) % 16) * 16 + ((col - 1 + 16) % 16);
            se = ((row + 1 + 16) % 16) * 16 + ((col + 1 + 16) % 16);
            sw = ((row + 1 + 16) % 16) * 16 + ((col - 1 + 16) % 16);

            neighbors = q[n] + q[s] + q[e] + q[w] + q[ne] + q[nw] + q[se] + q[sw];

            next_q[i] = (q[i] & (neighbors == 2 | neighbors == 3)) | (~q[i] & (neighbors == 3));
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule