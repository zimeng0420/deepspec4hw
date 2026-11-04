module top_module(
    input clk,
    input areset,
    input x,
    output z
);

  reg [1:0] current_state; // One-hot encoding: A = 2'b01, B = 2'b10
  wire [1:0] next_state;

  // State A is current_state[0] and State B is current_state[1]

  // Next state logic
  always @(*) begin
    if (current_state[0]) begin // State A
      next_state[0] = ~x; // Stay in A if x is 0
      next_state[1] = x;  // Go to B if x is 1
    } else begin // State B
      next_state[0] = 0;
      next_state[1] = 1; // Stay in B regardless of x
    end
  end

  // Output logic
  assign z = (current_state[0] & ~x) | (current_state[1] & ~x);

  // State register with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= 2'b01; // Reset to state A
    end else begin
      current_state <= next_state;
    end
  end

endmodule