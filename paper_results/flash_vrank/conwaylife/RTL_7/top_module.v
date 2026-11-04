module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q);

    reg [255:0] next_q;

    always @(*) begin
        for (int i = 0; i < 256; i++) begin
            int row = i / 16;
            int col = i % 16;
            int neighbours = 0;

            // Calculate neighbours (toroidal)
            for (int dr = -1; dr <= 1; dr++) begin
                for (int dc = -1; dc <= 1; dc++) begin
                    if (dr == 0 && dc == 0) continue; // Skip the cell itself

                    int neighbour_row = (row + dr + 16) % 16;
                    int neighbour_col = (col + dc + 16) % 16;
                    int neighbour_index = neighbour_row * 16 + neighbour_col;

                    neighbours += q[neighbour_index];
                }
            }

            // Apply game rules
            case (neighbours)
                0, 1: next_q[i] = 0; // Cell becomes 0
                2: next_q[i] = q[i];   // Cell state does not change
                3: next_q[i] = 1;     // Cell becomes 1
                default: next_q[i] = 0; // Cell becomes 0
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