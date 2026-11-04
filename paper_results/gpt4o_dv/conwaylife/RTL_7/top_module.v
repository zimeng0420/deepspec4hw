module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Internal wires
    wire [3:0] neighbor_count [15:0][15:0];
    wire next_state [15:0][15:0];

    // Compute the number of neighbors for each cell
    generate
        genvar x, y;
        for (x=0; x<16; x=x+1) begin: x_loop
            for (y=0; y<16; y=y+1) begin: y_loop

                // Address calculations with wrap-around using modulo arithmetic
                wire [3:0] xm1 = (x==0)  ? 15 : x-1;
                wire [3:0] xp1 = (x==15) ? 0  : x+1;
                wire [3:0] ym1 = (y==0)  ? 15 : y-1;
                wire [3:0] yp1 = (y==15) ? 0  : y+1;
                
                // Calculate the sum of the 8 neighbors
                assign neighbor_count[x][y] = 
                    q[ xm1 + 16 * ym1 ] + q[ x + 16 * ym1 ] + q[ xp1 + 16 * ym1 ] +
                    q[ xm1 + 16 * y   ] +                     q[ xp1 + 16 * y   ] +
                    q[ xm1 + 16 * yp1 ] + q[ x + 16 * yp1 ] + q[ xp1 + 16 * yp1 ];
                
                // Calculate next state
                assign next_state[x][y] = (neighbor_count[x][y] == 3) || 
                                          (q[x + 16*y] && neighbor_count[x][y] == 2);
            end
        end
    endgenerate

    // Sequential logic for loading or state update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            integer i, j;
            for (i=0; i<16; i=i+1) begin
                for (j=0; j<16; j=j+1) begin
                    q[i + 16*j] <= next_state[i][j];
                end
            end
        end
    end

endmodule