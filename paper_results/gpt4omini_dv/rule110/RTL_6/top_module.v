module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    reg [511:0] q_next;

    always @* begin
        q_next[0] = 0; // Boundary condition q[-1] = 0
        for (int i = 1; i < 511; i = i + 1) begin
            q_next[i] = (~q[i-1] & ~q[i] & ~q[i+1]) | 
                         (~q[i-1] & ~q[i] & q[i+1]) | 
                         (~q[i-1] & q[i] & ~q[i+1]) | 
                         (q[i-1] & ~q[i] & q[i+1]) | 
                         (q[i-1] & q[i] & ~q[i+1]);
        end
        q_next[511] = 0; // Boundary condition q[512] = 0
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= q_next;
    end
endmodule