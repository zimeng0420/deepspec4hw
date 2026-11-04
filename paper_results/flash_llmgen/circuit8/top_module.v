module top_module (
    input clock,
    input a,
    output reg p,
    output reg q
);

  always @(posedge clock) begin
    if (a == 1) begin
      // Stay in the current state
      p <= p;
      q <= q;
    end else begin
      // Toggle the state
      p <= ~p;
      q <= ~q;
    end
  end

endmodule