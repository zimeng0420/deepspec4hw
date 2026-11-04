module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q);

    always @(posedge clk) begin
        if (load) begin
            q <= data; // Load the data into q when load is high
        end
        else begin
            integer i;
            reg [511:0] next_q;
            for (i = 0; i < 512; i = i + 1) begin
                // Get left, center, and right cells
                reg left = (i == 0) ? 0 : q[i-1];
                reg center = q[i];
                reg right = (i == 511) ? 0 : q[i+1];
                
                // Apply Rule 110 to get the next state
                next_q[i] = (~left & center & ~right) | (~left & ~center & right) | (left & ~center & ~right) | (left & ~center & right) | (left & center & ~right);
            end
            q <= next_q; // Update the states of q with the next states
        end
    end

endmodule