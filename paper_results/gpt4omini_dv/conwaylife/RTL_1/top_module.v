module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    reg [255:0] next_q;

    always @* begin
        next_q = q; // Default to previous state
        for (integer i = 0; i < 256; i = i + 1) begin
            integer count = 0;
            // Get neighbor indices
            for (integer j = -1; j <= 1; j = j + 1) begin
                for (integer k = -1; k <= 1; k = k + 1) begin
                    if (j == 0 && k == 0) continue; // Skip self
                    // Wrap around for toroidal behavior
                    integer ni = (i / 16 + j + 16) % 16;
                    integer nj = (i % 16 + k + 16) % 16;
                    count += q[ni * 16 + nj]; // Count live neighbors
                end
            end
            // Determine next state based on neighbor count
            case (count)
                0, 1: next_q[i] = 0; // 0-1 neighbors -> dead
                2: next_q[i] = q[i];  // 2 neighbors -> unchanged
                3: next_q[i] = 1;     // 3 neighbors -> alive
                default: next_q[i] = 0; // 4+ neighbors -> dead
            endcase
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data; // Load data when load is high
        end else begin
            q <= next_q; // Update to next state
        end
    end
endmodule