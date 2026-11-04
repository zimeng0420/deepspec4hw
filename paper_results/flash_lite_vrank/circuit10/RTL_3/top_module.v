module top_module (
	input clk,
	input a,
	input b,
	output reg q,
	output reg state
);

  always @(posedge clk) begin
    if (a & b) begin
      q <= 0;
    end else if (~a & b) begin
      q <= 0;
    end else if (a & ~b) begin
      q <= 0;
    end else begin
      if (a == 0 & b == 0) begin
        q <= q;
      end else begin
        q <= q;
      end
    end
    
    if (a & b) begin
        state <= ~q;
    end else if (~a & b) begin
        state <= ~q;
    end else if (a & ~b) begin
        state <= ~q;
    end else if (~a & ~b) begin
      state <= q;
    end else
       state <= q;
  end
endmodule