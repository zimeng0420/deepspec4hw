module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] pedge);

  reg [7:0] prev_in;

  always @(posedge clk) begin
    prev_in <= in;
    pedge <= {8{1'b0}}; // Initialize pedge to 0 every clock cycle
    for (int i = 0; i < 8; i++) begin
      if (!prev_in[i] && in[i]) begin
        pedge[i] <= 1'b1;
      end
    end
  end

endmodule