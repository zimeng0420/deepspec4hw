module top_module(
	input clk,
	input reset,
	output reg [4:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // Reset to 1 (00001)
        end else begin
            // Calculate the new value for bit 5 (MSB)
            q[4] <= q[0] ^ q[2]; // XOR output with taps at 5 and 3

            // Shift the other bits
            q[0] <= q[1];
            q[1] <= q[2];
            q[2] <= q[3];
            q[3] <= q[4];
        end
    end

endmodule