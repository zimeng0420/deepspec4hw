module top_module(
	input clk,
	input L,
	input q_in,
	input r_in,
	output reg Q);

  // Flip-Flop implementation (D-type)
  reg D;
  always @(posedge clk) begin
    Q <= D;
  end

  // 2-1 Multiplexer implementation
  always @(*) begin
    if (L) begin
      D = r_in;
    end else begin
      D = q_in;
    end
  end

endmodule