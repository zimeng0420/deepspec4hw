module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] q_next;

    always @(posedge clk) begin
        if (load) 
            q <= data;
        else 
            q <= q_next;
    end

    always @(*) begin
        q_next[0] = (0 & q[0] & q[1]) | (0 & q[0] & ~q[1]) | (~0 & q[0] & q[1]) | (~0 & ~q[0] & q[1]) | (~0 & ~q[0] & ~q[1]);
        for (int i = 1; i < 511; i = i + 1) begin
            q_next[i] = (q[i-1] & q[i] & q[i+1]) | (q[i-1] & q[i] & ~q[i+1]) | (~q[i-1] & q[i] & q[i+1]) | (~q[i-1] & ~q[i] & q[i+1]) | (~q[i-1] & ~q[i] & ~q[i+1]);
        end
        q_next[511] = (q[510] & q[511] & 0) | (q[510] & q[511] & ~0) | (~q[510] & q[511] & 0) | (~q[510] & ~q[511] & 0) | (~q[510] & ~q[511] & ~0);
    end

endmodule