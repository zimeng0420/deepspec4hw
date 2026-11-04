module top_module(
	input clk,
	input L,
	input q_in,
	input r_in,
	output reg Q);

  reg D;

  always @(*) begin
    if (L) begin
      D = r_in;
    end else begin
      D = q_in;
    end
  end

  always @(posedge clk) begin
    Q <= D;
  end

endmodule