module top_module(
	input clk,
	input reset,
	output reg [31:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h1;
    end else begin
      // Calculate the XOR of the tapped bits and the current LSB
      wire xor_result = q[0] ^ q[1] ^ q[22] ^ q[31];

      // Shift the bits and update the LSB
      q[31:1] <= q[30:0];
      q[0] <= xor_result;
    end
  end

endmodule