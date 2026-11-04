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

    always @(*) begin
        for (int i = 0; i < 256; i++) begin
            int row = i / 16;
            int col = i % 16;
            int neighbors = 0;

            // Calculate neighbors (toroidal)
            neighbors = neighbors + q[((row + 15) % 16) * 16 + ((col + 15) % 16)];
            neighbors = neighbors + q[((row + 15) % 16) * 16 + ((col + 0) % 16)];
            neighbors = neighbors + q[((row + 15) % 16) * 16 + ((col + 1) % 16)];
            neighbors = neighbors + q[((row + 0) % 16) * 16 + ((col + 15) % 16)];
            neighbors = neighbors + q[((row + 0) % 16) * 16 + ((col + 1) % 16)];
            neighbors = neighbors + q[((row + 1) % 16) * 16 + ((col + 15) % 16)];
            neighbors = neighbors + q[((row + 1) % 16) * 16 + ((col + 0) % 16)];
            neighbors = neighbors + q[((row + 1) % 16) * 16 + ((col + 1) % 16)];

            // Apply Game of Life rules
            if (neighbors < 2) begin
                next_q[i] = 0;
            end else if (neighbors == 2) begin
                next_q[i] = q[i];
            end else if (neighbors == 3) begin
                next_q[i] = 1;
            end else begin
                next_q[i] = 0;
            end
        end
    end

endmodule