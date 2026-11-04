module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  // State Encoding
  localparam STATE_A = 2'b01;
  localparam STATE_B = 2'b10;

  reg [1:0] state;  // One-hot encoded state register
  wire next_state_A;
  wire next_state_B;

  // Next State Logic
  assign next_state_A = (state == STATE_A) && (x == 0);
  assign next_state_B = ((state == STATE_A) && (x == 1)) || (state == STATE_B);

  // Output Logic
  assign z = ((state == STATE_A) && (x == 1)) || ((state == STATE_B) && (x == 0));

  // State Transition Logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= STATE_A; // Reset to State A
    end else begin
      if (next_state_A) begin
        state <= STATE_A;
      end else if (next_state_B) begin
        state <= STATE_B;
      end
    end
  end

endmodule