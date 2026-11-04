module top_module(
	input clk,
	input L,
	input q_in,
	input r_in,
	output reg Q);

  reg d;

  always @(*) begin
    if (L) begin
      d = r_in;
    end else begin
      d = q_in;
    end
  end

  always @(posedge clk) begin
    Q <= d;
  end

endmodule