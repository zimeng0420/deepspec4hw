module top_module(
	input clk,
	input reset,
	input [31:0] in,
	output reg [31:0] out);

  reg [31:0] in_reg;

  always @(posedge clk) begin
    in_reg <= in;
  end

  always @(posedge clk) begin
    if (reset) begin
      out <= 32'b0;
    end else begin
      for (integer i = 0; i < 32; i = i + 1) begin
        if (in_reg[i] == 1'b1 && in[i] == 1'b0) begin
          out[i] <= 1'b1;
        end
      end
    end
  end

endmodule