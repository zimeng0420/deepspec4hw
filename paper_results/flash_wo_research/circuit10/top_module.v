module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state
);

  reg q_reg;
  assign q = q_reg;
  assign state = ((a ^ b) ? 1'b1 : 1'b0) ^ q;

  always @(posedge clk) begin
    q_reg <= ((a & b) | (~a & ~b)) ? q_reg : (a ^ b);
  end

endmodule