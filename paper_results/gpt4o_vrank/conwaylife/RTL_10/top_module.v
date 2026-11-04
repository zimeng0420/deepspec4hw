module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q);

    integer i, j;

    function [7:0] count_neighbors;
        input [255:0] grid;
        input integer row, col;
        integer r, c, ri, ci;
        begin
            count_neighbors = 0;
            for (r = -1; r <= 1; r = r + 1) begin
                for (c = -1; c <= 1; c = c + 1) begin
                    if (!(r == 0 && c == 0)) begin
                        ri = (row + r + 16) % 16;
                        ci = (col + c + 16) % 16;
                        count_neighbors = count_neighbors + grid[ri*16 + ci];
                    end
                end
            end
        end
    endfunction

    wire [255:0] next_state;

    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                case (count_neighbors(q, i, j))
                    3: next_state[i*16 + j] = 1'b1;
                    2: next_state[i*16 + j] = q[i*16 + j];
                    default: next_state[i*16 + j] = 1'b0;
                endcase
            end
        end
    end

    always @(posedge clk) begin
        if (load) 
            q <= data;
        else 
            q <= next_state;
    end

endmodule