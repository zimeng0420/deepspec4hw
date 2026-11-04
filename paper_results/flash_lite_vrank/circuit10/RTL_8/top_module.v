module top_module (
	input clk,
	input a,
	input b,
	output reg q,
	output reg state
);

  always @(posedge clk) begin
    if (a & b) begin
      q <= ~q;
    end else if (a | b) begin
        if(a ^ b)
            q <= q;
        else
            q <= q;
    end else begin
      q <= q;
    end
    state <= q;
  end
endmodule