module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] q_next;
    
    integer i;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Boundary handling
            q_next[0] = 0 ^ q[1];
            q_next[511] = q[510] ^ 0;
            
            // Core logic for internal cells
            for (i = 1; i < 511; i = i + 1) begin
                q_next[i] = q[i-1] ^ q[i+1];
            end
            
            // Update the current state
            q <= q_next;
        end
    end

endmodule