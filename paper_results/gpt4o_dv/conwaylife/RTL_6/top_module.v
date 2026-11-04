module top_module (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    integer x, y, i, j;
    reg [3:0] neighbors; // To store neighbor count

    // Combinational logic to calculate next state
    always @(*) begin
        for (x = 0; x < 16; x = x + 1) begin
            for (y = 0; y < 16; y = y + 1) begin
                neighbors = 0;
                // Calculate index for neighbors with modulo wrap-around for toroid
                for (i = -1; i <= 1; i = i + 1) begin
                    for (j = -1; j <= 1; j = j + 1) begin
                        if (i != 0 || j != 0) begin // Ignore the cell itself
                            neighbors = neighbors +
                                q[((x + i + 16) % 16) + ((y + j + 16) % 16) * 16];
                        end
                    end
                end
                
                // Determine next state for cell (x, y)
                case (neighbors)
                    2: q_next[x + y*16] = q[x + y*16]; // Stay the same
                    3: q_next[x + y*16] = 1; // Alive
                    default: q_next[x + y*16] = 0; // Dead
                endcase
            end
        end
    end

    // Sequential logic to update the state of the grid
    always @(posedge clk) begin
        if (load)
            q <= data; // Load initial state
        else
            q <= q_next; // Update to next state
    end

endmodule