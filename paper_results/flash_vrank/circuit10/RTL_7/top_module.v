module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state
);

  reg state_reg;
  wire state_next;

  assign state = state_reg;
  assign q = state_reg;

  always @(posedge clk) begin
    state_reg <= state_next;
  end

  assign state_next = (~a & b) | (a & b & state_reg) | (a & ~b & state_reg);

endmodule