module top_module(
	input clk,
	input reset,
	output reg [31:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      // Calculate the XOR of the tapped bits and the output bit
      reg feedback;
      feedback = q[31] ^ q[21] ^ q[1] ^ q[0];

      // Shift the register and update the bits
      q[31:1] <= q[30:0];
      q[0] <= feedback;
    end
  end

endmodule