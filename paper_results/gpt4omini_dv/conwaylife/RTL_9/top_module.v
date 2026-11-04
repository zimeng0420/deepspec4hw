module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

always @* begin
    integer i, j, count;
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            count = 0;
            // Count live neighbors using toroidal wrap-around
            for (integer di = -1; di <= 1; di = di + 1) begin
                for (integer dj = -1; dj <= 1; dj = dj + 1) begin
                    if (di == 0 && dj == 0)
                        continue;
                    count = count + q[((i + di + 16) % 16) * 16 + ((j + dj + 16) % 16)];
                end
            end
            // Apply rules of Game of Life
            if (q[i * 16 + j] == 1) begin
                if (count < 2 || count > 3)
                    next_q[i * 16 + j] = 0; // Death
                else
                    next_q[i * 16 + j] = 1; // Lives on
            end else begin
                if (count == 3)
                    next_q[i * 16 + j] = 1; // Comes to life
                else
                    next_q[i * 16 + j] = 0; // Stays dead
            end
        end
    end
end

always @(posedge clk) begin
    if (load)
        q <= data; // Load data on high
    else
        q <= next_q; // Update state
end

endmodule