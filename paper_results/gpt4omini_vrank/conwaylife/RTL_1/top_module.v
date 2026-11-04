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
        next_q = 256'b0;
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int count = 0;
                for (int di = -1; di <= 1; di++) begin
                    for (int dj = -1; dj <= 1; dj++) begin
                        if (di == 0 && dj == 0) continue; // skip the cell itself
                        int ni = (i + di + 16) % 16; // toroidal wrap
                        int nj = (j + dj + 16) % 16; // toroidal wrap
                        count += q[ni*16 + nj];
                    end
                end
                
                case (count)
                    0, 1: next_q[i*16 + j] = 0;
                    2: next_q[i*16 + j] = q[i*16 + j];
                    3: next_q[i*16 + j] = 1;
                    default: next_q[i*16 + j] = 0;
                endcase
            end
        end
    end
endmodule