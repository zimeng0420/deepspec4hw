module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q);

    integer i, j;
    reg [3:0] count;
    reg [15:0] q_matrix [15:0];
    reg [15:0] next_q_matrix [15:0];

    // Convert the 1D input data to a 2D matrix
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            q_matrix[i] = q[i*16 +: 16];
        end
    end

    // Count neighbors for each cell in the grid
    function [3:0] neighbor_count;
        input [15:0] row, col;
        integer k;
        begin
            count = 0;
            for (k = -1; k <= 1; k = k + 1) begin
                if (k != 0) begin
                    // Check above and below rows with wrap-around
                    count = count + q_matrix[(row + k + 16) % 16][col];
                    // Check left and right neighbours with wrap-around in the same row
                    count = count + q_matrix[row][(col + k + 16) % 16];
                end
                // Check diagonal neighbours with wrap-around
                count = count + q_matrix[(row + k + 16) % 16][(col + k + 16) % 16];
                count = count + q_matrix[(row + k + 16) % 16][(col - k + 16) % 16];
            end
            neighbor_count = count;
        end
    endfunction

    // Compute next state matrix
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // Count the neighbors
                count = neighbor_count(i, j) - q_matrix[i][j];
                // Apply rules of the game
                case (count)
                    2: next_q_matrix[i][j] = q_matrix[i][j]; // State remain unchanged
                    3: next_q_matrix[i][j] = 1;             // Cell becomes alive
                    default: next_q_matrix[i][j] = 0;       // Cell becomes dead
                endcase
            end
        end
    end

    // Update grid on each clock cycle
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (i = 0; i < 16; i = i + 1) begin
                q[i*16 +: 16] <= next_q_matrix[i];
            end
        end
    end

endmodule