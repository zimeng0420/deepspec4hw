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
        for (int i = 0; i < 512; i = i + 1) begin
            // Determine neighbors, handling boundary conditions
            logic left;
            logic right;

            if (i == 0) begin
                left = 0;
            end else begin
                left = q[i - 1];
            end

            if (i == 511) begin
                right = 0;
            end else begin
                right = q[i + 1];
            end

            // Implement Rule 110
            q[i] <= (left & q[i] & ~right) | (left & ~q[i] & right) | (~left & q[i] & right) | (~left & ~q[i] & right);
        end
    end
end

endmodule