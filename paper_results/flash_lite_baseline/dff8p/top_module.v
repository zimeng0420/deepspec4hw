module top_module(
	input clk,
	input [7:0] d,
	input reset,
	output reg [7:0] q
);

  reg [7:0] q_internal [7:0];

  integer i;

  always @(negedge clk) begin
    if (reset) begin
      for (i = 0; i < 8; i = i + 1) begin
        q_internal[i] <= 8'h34;
      end
    end else begin
      for (i = 0; i < 8; i = i + 1) begin
        q_internal[i] <= d;
      end
    end
  end

  always @(*) begin
    q = q_internal[0];
  end

endmodule