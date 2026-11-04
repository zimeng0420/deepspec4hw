module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;
    integer i, j;
    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    integer cell_index = i * 16 + j;
                    integer neighbor_count = 0;
                    
                    // Calculate neighbor indices with toroidal boundary conditions
                    integer tl_row = (i - 1 + 16) % 16;
                    integer tl_col = (j - 1 + 16) % 16;
                    integer t_row = (i - 1 + 16) % 16;
                    integer t_col = j;
                    integer tr_row = (i - 1 + 16) % 16;
                    integer tr_col = (j + 1) % 16;
                    integer l_row = i;
                    integer l_col = (j - 1 + 16) % 16;
                    integer r_row = i;
                    integer r_col = (j + 1) % 16;
                    integer bl_row = (i + 1) % 16;
                    integer bl_col = (j - 1 + 16) % 16;
                    integer b_row = (i + 1) % 16;
                    integer b_col = j;
                    integer br_row = (i + 1) % 16;
                    integer br_col = (j + 1) % 16;
                    
                    // Count live neighbors
                    neighbor_count = data[tl_row * 16 + tl_col] + data[t_row * 16 + t_col] + data[tr_row * 16 + tr_col] +
                                     data[l_row * 16 + l_col] + data[r_row * 16 + r_col] +
                                     data[bl_row * 16 + bl_col] + data[b_row * 16 + b_col] + data[br_row * 16 + br_col];
                    
                    // Apply Game of Life rules
                    if (data[cell_index] == 1) begin // Current cell is alive
                        if (neighbor_count < 2) begin
                            next_q[cell_index] = 0;
                        end else if (neighbor_count == 2 || neighbor_count == 3) begin
                            next_q[cell_index] = 1;
                        end else begin // neighbor_count > 3
                            next_q[cell_index] = 0;
                        end
                    end else begin // Current cell is dead
                        if (neighbor_count == 3) begin
                            next_q[cell_index] = 1;
                        end else begin
                            next_q[cell_index] = 0;
                        end
                    end
                end
            end
            q <= next_q;
        end
    end

endmodule