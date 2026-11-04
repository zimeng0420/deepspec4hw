module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

always @(*) begin
    for (int i = 0; i < 256; i++) begin
        int row = i / 16;
        int col = i % 16;
        int neighbors = 0;

        // Calculate neighbors (toroidal)
        for (int dr = -1; dr <= 1; dr++) {
            for (int dc = -1; dc <= 1; dc++) {
                if (dr == 0 && dc == 0) continue; // Skip itself
                int neighbor_row = (row + dr + 16) % 16;
                int neighbor_col = (col + dc + 16) % 16;
                neighbors += q[neighbor_row * 16 + neighbor_col];
            }
        }

        // Apply Game of Life rules
        case (neighbors)
            0, 1: next_q[i] = 0;
            2: next_q[i] = q[i];
            3: next_q[i] = 1;
            default: next_q[i] = 0;
        endcase
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