module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q);

    integer i;
    reg [511:0] next_q;

    always @(*) begin
        // Compute the next state based on Rule 110
        next_q[0] = (~q[1] & q[0]); // Left neighbor q[-1] is 0
        for (i = 1; i < 511; i = i + 1) begin
            next_q[i] = (~q[i+1] & q[i]) | (~q[i-1] & q[i+1]) | (q[i-1] & ~q[i] & q[i+1]);
        end
        next_q[511] = (~q[510] & q[511]); // Right neighbor q[512] is 0
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data; // Load the input data into q
        end
        else begin
            q <= next_q; // Update q with the next state
        end
    end
endmodule