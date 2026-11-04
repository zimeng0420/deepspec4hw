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
        for (int i = 0; i < 256; i = i + 1) begin
            int count = 0;
            for (int dx = -1; dx <= 1; dx = dx + 1) begin
                for (int dy = -1; dy <= 1; dy = dy + 1) begin
                    if (dx == 0 && dy == 0) continue;
                    int x = (i % 16 + dx + 16) % 16;
                    int y = (i / 16 + dy + 16) % 16;
                    count += q[y * 16 + x];
                end
            end
            case (count)
                0, 1: next_q[i] = 0;
                2: next_q[i] = q[i];
                3: next_q[i] = 1;
                default: next_q[i] = 0;
            endcase
        end
    end
endmodule