module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] q_next;

    always @(*) begin
        q_next[0] = 0; // q[-1] = 0 (left boundary)
        q_next[511] = 0; // q[512] = 0 (right boundary)

        for (int i = 1; i < 511; i = i + 1) begin
            q_next[i] = (q[i-1] & q[i] & q[i+1]) ? 0 :
                         (q[i-1] & q[i] & ~q[i+1]) ? 1 :
                         (q[i-1] & ~q[i] & q[i+1]) ? 1 :
                         (~q[i-1] & q[i] & q[i+1]) ? 1 :
                         (~q[i-1] & ~q[i] & ~q[i+1]) ? 0 :
                         (q[i] & ~q[i+1]) ? 1 :
                         (~q[i] & q[i+1]) ? 1 : 0;
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= q_next;
        end
    end

endmodule