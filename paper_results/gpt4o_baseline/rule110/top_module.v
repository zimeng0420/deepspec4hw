module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    integer i;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            reg [511:0] next_q;

            for (i = 0; i < 512; i = i+1) begin
                // Define the neighbors with boundaries set to 0
                reg left, center, right;
                left = (i == 0) ? 1'b0 : q[i-1];
                center = q[i];
                right = (i == 511) ? 1'b0 : q[i+1];

                // Apply Rule 110 based on neighbors
                next_q[i] = (left & center & ~right) |
                            (left & ~center & right) |
                            (~left & center & right) |
                            (~left & center & ~right);
            end

            q <= next_q;
        end
    end
endmodule