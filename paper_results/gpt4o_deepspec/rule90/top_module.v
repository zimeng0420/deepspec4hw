module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q);

    reg [511:0] q_next;

    always @(*) begin
        q_next[0] = q[1]; // Boundary condition for first cell (q[0])
        q_next[511] = q[510]; // Boundary condition for last cell (q[511])
        // Core logic for Rule 90: XOR of two neighbors
        for (integer i = 1; i < 511; i = i + 1) begin
            q_next[i] = q[i-1] ^ q[i+1];
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data; // Load data into q
        end else begin
            q <= q_next; // Update state based on Rule 90 computation
        end
    end

endmodule