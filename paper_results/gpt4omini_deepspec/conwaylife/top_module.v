module top_module(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;

    wire [8:0] neighbor_count [0:255];

    // Neighbor counting logic
    generate
        genvar i, j;
        for (i = 0; i < 16; i = i + 1) begin: row
            for (j = 0; j < 16; j = j + 1) begin: col
                assign neighbor_count[i * 16 + j] = 
                    q[((i-1+16)%16) * 16 + ((j-1+16)%16)] +
                    q[((i-1+16)%16) * 16 + j] +
                    q[((i-1+16)%16) * 16 + ((j+1)%16)] +
                    q[i * 16 + ((j-1+16)%16)] +
                    q[i * 16 + ((j+1)%16)] +
                    q[((i+1)%16) * 16 + ((j-1+16)%16)] +
                    q[((i+1)%16) * 16 + j] +
                    q[((i+1)%16) * 16 + ((j+1)%16)];
            end
        end
    endgenerate

    // State transition logic
    always @(*) begin
        for (int idx = 0; idx < 256; idx = idx + 1) begin
            case (neighbor_count[idx])
                0, 1, 4: next_q[idx] = 0; // Cell becomes 0
                2: next_q[idx] = q[idx];   // Cell stays the same
                3: next_q[idx] = 1;         // Cell becomes 1
                default: next_q[idx] = 0;   // 4+ neighbors -> dead
            endcase
        end
    end

    // Sequential logic
    always @(posedge clk) begin
        if (load) begin
            q <= data; // Load initial state
        end else begin
            q <= next_q; // Update state
        end
    end

endmodule