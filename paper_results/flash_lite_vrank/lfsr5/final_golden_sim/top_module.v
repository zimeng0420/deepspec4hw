module top_module(
	input clk,
	input reset,
	output reg [4:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001; // Reset to 1
    end else begin
      q[0] <= q[4] ^ q[2]; // Tap at bits 5 and 3 (4 and 2 in Verilog indexing)
      q[1] <= q[0];
      q[2] <= q[1];
      q[3] <= q[2];
      q[4] <= q[3];
    end
  end

endmodule