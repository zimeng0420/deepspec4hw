module top_module(
	input clk,
	input reset,
	output reg [3:0] q
);

  reg [3:0] count;

  always @(posedge clk) begin
    if (reset) begin
      count <= 4'b0001; // Reset to 1
    end else begin
      if (count == 4'b1010) begin // Check if count is 10
        count <= 4'b0001; // Cycle back to 1
      end else begin
        count <= count + 1'b1; // Increment
      end
    end
  end

  always @(*) begin
    q = count;
  end

endmodule