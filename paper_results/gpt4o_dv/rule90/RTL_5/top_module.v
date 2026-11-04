module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] q_next;

    always @(*) begin
        q_next[0] = q[1]; // q[-1] is 0, q[0] = 0 XOR q[1]
        q_next[511] = q[510]; // q[512] is 0, q[511] = q[510] XOR 0
        
        // Core logic for internal cells
        for (int i = 1; i < 511; i++) begin
            q_next[i] = q[i-1] ^ q[i+1];
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