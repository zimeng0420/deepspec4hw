module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q
);

  reg [511:0] next_q;

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      // Calculate the next state for each cell
      for (int i = 0; i < 512; i = i + 1) begin
        // Handle boundary conditions: q[-1] and q[512] are 0
        next_q[i] = (i == 0 ? 0 ^ q[i+1] : (i == 511 ? q[i-1] ^ 0 : q[i-1] ^ q[i+1]));
      end
      q <= next_q;
    end
  end

endmodule