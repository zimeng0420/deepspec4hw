module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state
);

  reg state_r;  // Internal register for the state
  wire next_state;

  // Next State Logic
  assign next_state = (a & b) | (~a & ~b & state_r);

  // Output Logic
  assign q = (a ^ b) ^ state_r;

  // Flip-Flop (State Update)
  always @(posedge clk) begin
    state_r <= next_state;
  end

  // Output assignment (making the internal state observable)
  assign state = state_r;

endmodule