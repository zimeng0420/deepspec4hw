module top_module(
	input clk,
	input reset,
	output reg [4:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001; // Reset to 1 (LSB)
    end else begin
      // Calculate the XOR of tap bits (5 and 3)
      q <= {q[0] ^ q[2], q[4], q[3], q[2], q[1]};
    end
  end
endmodule