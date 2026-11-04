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
            int neighbors = 0;

            // Calculate neighbors with toroidal boundary conditions
            int row_up = (row == 0) ? 15 : row - 1;
            int row_down = (row == 15) ? 0 : row + 1;
            int col_left = (col == 0) ? 15 : col - 1;
            int col_right = (col == 15) ? 0 : col + 1;

            neighbors += q[row_up * 16 + col_left];
            neighbors += q[row_up * 16 + col];
            neighbors += q[row_up * 16 + col_right];
            neighbors += q[row * 16 + col_left];
            neighbors += q[row * 16 + col_right];
            neighbors += q[row_down * 16 + col_left];
            neighbors += q[row_down * 16 + col];
            neighbors += q[row_down * 16 + col_right];
            
            // Apply Conway's Game of Life rules
            if (neighbors < 2 || neighbors > 3) begin
                next_q[i] = 0;
            } else if (neighbors == 3) begin
                next_q[i] = 1;
            } else begin
                next_q[i] = q[i];
            end
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