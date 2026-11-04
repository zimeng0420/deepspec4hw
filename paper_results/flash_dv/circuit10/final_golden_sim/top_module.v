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
    if (a == 0 && b == 0) begin
      q <= q;
    end else if (a == 0 && b == 1) begin
      q <= ~q;
    end else if (a == 1 && b == 0) begin
      q <= ~q;
    end else if (a == 1 && b == 1) begin
      q <= ~q;
    end
  end

endmodule