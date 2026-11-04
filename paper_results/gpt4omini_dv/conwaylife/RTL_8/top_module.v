module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;

    always @(*) begin
        integer i, j, neighbor_count;
        next_q = q; // Default to current state

        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                neighbor_count = 0;

                // Count neighbors with wrap-around (toroidal grid)
                for (integer di = -1; di <= 1; di = di + 1) begin
                    for (integer dj = -1; dj <= 1; dj = dj + 1) begin
                        if (di == 0 && dj == 0) continue; // Skip the cell itself

                        neighbor_count = neighbor_count + 
                            q[( (i + di + 16) % 16) * 16 + ((j + dj + 16) % 16)];
                    end
                end

                // Update next_q based on current state and neighbor count
                case (neighbor_count)
                    0, 1: next_q[i * 16 + j] = 0; // Cell becomes 0
                    2: next_q[i * 16 + j] = q[i * 16 + j]; // Cell stays the same
                    3: next_q[i * 16 + j] = 1; // Cell becomes 1
                    default: next_q[i * 16 + j] = 0; // Cell becomes 0
                endcase
            end
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data; // Load new data into q
        end else begin
            q <= next_q; // Update q to the next state
        end
    end

endmodule