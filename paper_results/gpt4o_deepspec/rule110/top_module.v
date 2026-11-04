module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;  // Load data when load signal is high
        end else begin
            // Apply Rule 110 logic to calculate next state of each cell
            q[0] <= (~0 & q[0] & ~q[1]) |
                    (~0 & ~q[0] & q[1]) |
                    (0 & ~q[0] & ~q[1]) |
                    (0 & ~q[0] & q[1]) |
                    (0 & q[0] & ~q[1]);
            
            q[511}]"