module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  // Define the two states
  localparam PASSING = 1'b0;
  localparam INVERTING = 1'b1;

  // State register
  reg current_state;
  reg next_state;

  // Output z
  assign z = (current_state == PASSING) ? x : ~x;

  // State transition logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= PASSING;
    end else begin
      current_state <= next_state;
    end
  end

  // Next state logic
  always @(*) begin
    if (current_state == PASSING && x == 1'b1) begin
      next_state = INVERTING;
    end else begin
      next_state = current_state;
    end
  end

endmodule