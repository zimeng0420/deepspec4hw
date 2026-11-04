module top_module(
	input clk,
	input load,
	input [255:0] data,
	output reg [255:0] q
);

    reg [255:0] next_q;
    
    function [2:0] count_neighbors;
        input [7:0] row_index;
        input [7:0] col_index;
        input [255:0] grid;
        
        reg [2:0] count;
        integer i, j;
        begin
            count = 0;
            for (i = row_index - 1; i <= row_index + 1; i = i + 1) begin
                for (j = col_index - 1; j <= col_index + 1; j = j + 1) begin
                    if ((i == row_index) && (j == col_index)) begin
                        // Skip the cell itself
                    end else begin
                        if (grid[((i[3:0] + 16) % 16) * 16 + ((j[3:0] + 16) % 16)]) begin
                            count = count + 1;
                        end
                    end
                end
            end
            count_neighbors = count;
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            integer i, j;
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    case (count_neighbors(i, j, q))
                        0, 1: next_q[i * 16 + j] <= 0;
                        2: next_q[i * 16 + j] <= q[i * 16 + j];
                        3: next_q[i * 16 + j] <= 1;
                        4, 5, 6, 7, 8: next_q[i * 16 + j] <= 0;
                    endcase
                end
            end
            q <= next_q;
        end
    end

endmodule