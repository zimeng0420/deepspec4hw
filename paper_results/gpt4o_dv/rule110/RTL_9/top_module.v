module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute the next state based on Rule 110
            // With boundaries q[-1] = 0 and q[512] = 0
            reg [511:0] next_q;
            integer i;
            // Update each cell
            for (i = 0; i < 512; i = i + 1) begin
                // Left neighbor
                wire left = (i == 0) ? 0 : q[i-1];
                // Right neighbor
                wire right = (i == 511) ? 0 : q[i+1];
                
                // Apply Rule 110
                next_q[i] = (~left & q[i] & ~right) | 
                            (~left & ~q[i] & right) | 
                            (left & ~q[i] & ~right) | 
                            (left & ~q[i] & right) | 
                            (left & q[i] & ~right);
            end
            q <= next_q;
        end
    end
endmodule