module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q);

    wire [255:0] next_state;

    // Function to calculate neighbor indices with toroidal wrap-around
    function [8:0] neighbor_indices;
        input integer x, y;
        begin
            neighbor_indices[0] = ((x - 1 + 16) % 16) + 16 * ((y - 1 + 16) % 16);
            neighbor_indices[1] = ((x) % 16) + 16 * ((y - 1 + 16) % 16);
            neighbor_indices[2] = ((x + 1) % 16) + 16 * ((y - 1 + 16) % 16);
            neighbor_indices[3] = ((x - 1 + 16) % 16) + 16 * ((y) % 16);
            neighbor_indices[4] = ((x + 1) % 16) + 16 * ((y) % 16);
            neighbor_indices[5] = ((x - 1 + 16) % 16) + 16 * ((y + 1) % 16);
            neighbor_indices[6] = ((x) % 16) + 16 * ((y + 1) % 16);
            neighbor_indices[7] = ((x + 1) % 16) + 16 * ((y + 1) % 16);
        end
    endfunction

    // Combinational logic to calculate the next state of the grid
    generate
        genvar i, j;
        for (i = 0; i < 16; i = i + 1) begin : row
            for (j = 0; j < 16; j = j + 1) begin : col
                wire [8:0] indices = neighbor_indices(i, j);
                wire [3:0] neighbors_alive;
                
                assign neighbors_alive = q[indices[0]] + q[indices[1]] + q[indices[2]] +
                                         q[indices[3]] + q[indices[4]] + 
                                         q[indices[5]] + q[indices[6]] + q[indices[7]];

                always @* begin
                    case (neighbors_alive)
                        4'd2: next_state[i*16 + j] = q[i*16 + j];
                        4'd3: next_state[i*16 + j] = 1'b1;
                        default: next_state[i*16 + j] = 1'b0;
                    endcase
                end
            end
        end
    endgenerate

    // Update the state of the grid every clock cycle
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule