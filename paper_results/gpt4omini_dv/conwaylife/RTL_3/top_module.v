module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;

    always @* begin
        integer i, j;
        integer count;
        next_q = q;

        for (i = 0; i < 16; i++) begin
            for (j = 0; j < 16; j++) begin
                count = 0;

                // Count alive neighbors
                for (integer di = -1; di <= 1; di++) begin
                    for (integer dj = -1; dj <= 1; dj++) begin
                        if (di == 0 && dj == 0) continue;
                        count += q[((i + di + 16) % 16) * 16 + ((j + dj + 16) % 16)];
                    end
                end

                // Apply Game of Life rules
                if (q[i * 16 + j]) begin
                    if (count < 2 || count > 3)
                        next_q[i * 16 + j] = 0; // Dies
                end else begin
                    if (count == 3)
                        next_q[i * 16 + j] = 1; // Comes to life
                end
            end
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data; // Load new state
        end else begin
            q <= next_q; // Update to next state
        end
    end

endmodule