module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

integer i;

always @(*) begin
    for (i = 0; i < 256; i = i + 1) begin
        integer x, y, neighbors;
        x = i % 16;
        y = i / 16;
        neighbors = 0;

        // Calculate neighbors (toroidal)
        neighbors = neighbors + q[((y - 1 + 16) % 16) * 16 + x];
        neighbors = neighbors + q[((y + 1 + 16) % 16) * 16 + x];
        neighbors = neighbors + q[y * 16 + (x + 1 + 16) % 16];
        neighbors = neighbors + q[y * 16 + (x - 1 + 16) % 16];
        neighbors = neighbors + q[((y - 1 + 16) % 16) * 16 + (x + 1 + 16) % 16];
        neighbors = neighbors + q[((y - 1 + 16) % 16) * 16 + (x - 1 + 16) % 16];
        neighbors = neighbors + q[((y + 1 + 16) % 16) * 16 + (x + 1 + 16) % 16];
        neighbors = neighbors + q[((y + 1 + 16) % 16) * 16 + (x - 1 + 16) % 16];

        // Game of Life rules
        if (q[i] == 1) begin
            if (neighbors < 2 || neighbors > 3) begin
                next_q[i] = 0;
            end else begin
                next_q[i] = 1;
            end
        end else begin
            if (neighbors == 3) begin
                next_q[i] = 1;
            end else begin
                next_q[i] = 0;
            end
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