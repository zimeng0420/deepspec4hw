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
        integer i, j, count;
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                count = 0;
                // Count neighbours in toroidal manner
                for (integer x = -1; x <= 1; x = x + 1) begin
                    for (integer y = -1; y <= 1; y = y + 1) begin
                        if (x == 0 && y == 0) continue;
                        count = count + q[{(i + x + 16) % 16, (j + y + 16) % 16}];
                    end
                end

                // Determine next state based on count of neighbours
                case (count)
                    0, 1, 4: next_q[{i, j}] = 0;
                    2: next_q[{i, j}] = q[{i, j}]; // State unchanged
                    3: next_q[{i, j}] = 1;
                    default: next_q[{i, j}] = 0;
                endcase
            end
        end
    end

endmodule