module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    integer i;
    reg [511:0] next_state;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (i = 0; i < 512; i = i + 1) begin
                if (i == 0) begin
                    // Left boundary: q[-1] = 0, Center = q[0], Right = q[1]
                    next_state[i] <= (q[i] & ~q[i+1]) | (~q[i+1] & q[i+1]) | (q[i] & q[i+1]);
                end else if (i == 511) begin
                    // Right boundary: Left = q[510], Center = q[511], q[512] = 0
                    next_state[i] <= (q[i-1] & ~q[i]) | (~q[i] & 0) | (q[i-1] & 0);
                end else begin
                    // General case: Left = q[i-1], Center = q[i], Right = q[i+1]
                    next_state[i] <= (q[i-1] & ~q[i] & q[i+1]) | (~q[i-1] & q[i] & ~q[i+1]) | (~q[i-1] & ~q[i] & q[i+1]) | (q[i-1] & q[i] & ~q[i+1]) | (q[i-1] & ~q[i] & ~q[i+1]);
                end
            end
            q <= next_state;
        end
    end

endmodule