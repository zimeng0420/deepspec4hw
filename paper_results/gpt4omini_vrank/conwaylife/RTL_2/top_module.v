module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;
    integer i, j, count;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

    always @* begin
        next_q = 256'b0; // Initialize next state
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                count = 0;
                // Count the alive neighbors, considering toroidal connections
                for (integer di = -1; di <= 1; di = di + 1) begin
                    for (integer dj = -1; dj <= 1; dj = dj + 1) begin
                        if (di == 0 && dj == 0) continue; // Skip self
                        count = count + q[(((i + di + 16) % 16) * 16) + ((j + dj + 16) % 16)];
                    end
                end

                // Apply Game of Life rules
                case (count)
                    0, 1: next_q[((i * 16) + j)] = 0;
                    2: next_q[((i * 16) + j)] = q[((i * 16) + j)]; // State unchanged
                    3: next_q[((i * 16) + j)] = 1;
                    default: next_q[((i * 16) + j)] = 0;
                endcase
            end
        end
    end
endmodule