module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    integer i, j;
    reg [7:0] neighbor_count [15:0][15:0];

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    neighbor_count[i][j] = 
                        q[(i == 0 ? 15 : i - 1) * 16 + (j == 0 ? 15 : j - 1)] + // top-left
                        q[(i == 0 ? 15 : i - 1) * 16 + j] +                          // top
                        q[(i == 0 ? 15 : i - 1) * 16 + (j == 15 ? 0 : j + 1)] +    // top-right
                        q[i * 16 + (j == 0 ? 15 : j - 1)] +                          // left
                        q[i * 16 + (j == 15 ? 0 : j + 1)] +                          // right
                        q[(i == 15 ? 0 : i + 1) * 16 + (j == 0 ? 15 : j - 1)] +    // bottom-left
                        q[(i == 15 ? 0 : i + 1) * 16 + j] +                          // bottom
                        q[(i == 15 ? 0 : i + 1) * 16 + (j == 15 ? 0 : j + 1)];      // bottom-right
                end
            end
            
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    if (q[i * 16 + j] == 1'b1) begin
                        if (neighbor_count[i][j] < 2 || neighbor_count[i][j] >= 4)
                            q[i * 16 + j] <= 1'b0; // Cell dies
                    end else begin
                        if (neighbor_count[i][j] == 3)
                            q[i * 16 + j] <= 1'b1; // Cell comes to life
                    end
                end
            end
        end
    end
endmodule