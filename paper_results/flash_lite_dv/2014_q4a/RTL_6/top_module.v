module top_module(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

  // Use a conditional assignment for the multiplexer logic
  always @(posedge clk) begin
    if (L) begin
      Q <= R;
    end else if (E) begin
      Q <= w;
    end
  end

endmodule