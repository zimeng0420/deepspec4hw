module top_module(
    input clk,
    input x,
    input areset,
    output z
);

  reg [1:0] current_state; // One-hot encoding: A = 2'b01, B = 2'b10
  wire [1:0] next_state;
  wire state_A, state_B;

  // State assignment
  assign state_A = current_state[0];
  assign state_B = current_state[1];

  // Next state logic
  assign next_state[0] = state_A & ~x;
  assign next_state[1] = (state_A & x) | state_B;

  // Output logic
  assign z = (state_A & ~x) | (state_B & ~x);
  // State update
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= 2'b01; // Reset to state A
    end else begin
      current_state <= next_state;
    end
  end

endmodule