module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    reg [255:0] next_q;
    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end
    
    always @* begin
        integer i;
        for (i = 0; i < 256; i = i + 1) begin
            next_q[i] = q[i]; // Default behavior (stays the same)
            int neighbors = count_neighbors(i);
            if (neighbors <= 1) begin
                next_q[i] = 0; // Rule 1
            end else if (neighbors == 3) begin
                next_q[i] = 1; // Rule 3
            end else if (neighbors >= 4) begin
                next_q[i] = 0; // Rule 4
            end
        end
    end
    
    function integer count_neighbors(input integer idx);
        integer row, col, nrow, ncol, count;
        begin
            count = 0;
            row = idx / 16;
            col = idx % 16;
            for (nrow = row - 1; nrow <= row + 1; nrow = nrow + 1) begin
                for (ncol = col - 1; ncol <= col + 1; ncol = ncol + 1) begin
                    if (nrow == row && ncol == col) continue; // Skip self
                    count = count + q[((nrow + 16) % 16) * 16 + ((ncol + 16) % 16)];
                end
            end
            count_neighbors = count;
        end
    endfunction
endmodule