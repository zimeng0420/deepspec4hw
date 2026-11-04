module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state
);

  reg q;
  assign state = q;

  always @(posedge clk) begin
    q <= ((!a) & (b) & (!q)) |
         ((a) & (!b) & (!q)) |
         ((a) & (b) & (q)) |
         (((!a) & (!b)) & (q)) |
		 ((a) & (!b) & (q)) |
		 ((!a) & (b) & (q));
  end

endmodule