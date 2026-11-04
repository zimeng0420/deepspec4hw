module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            // Determine neighbors, handling boundaries
            logic left = (i == 0) ? 0 : q[i - 1];
            logic right = (i == 511) ? 0 : q[i + 1];

            // Implement Rule 110
            q[i] <= (left & q[i] & ~right) | (left & ~q[i] & right) | (~left & q[i] & right) | (~left & ~q[i] & right);
        end
    end
end

endmodule