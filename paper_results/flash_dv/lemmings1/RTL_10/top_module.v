module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

  // Define the two states
  localparam WALK_LEFT = 1'b0;
  localparam WALK_RIGHT = 1'b1;

  // State variable
  reg current_state;

  // Output assignments (Moore machine)
  assign walk_left = (current_state == WALK_LEFT);
  assign walk_right = (current_state == WALK_RIGHT);

  // State update logic
  always_ff @(posedge clk, posedge areset) begin
    if (areset) begin
      current_state <= WALK_LEFT;
    end else begin
      if (bump_left || bump_right) begin // Switch direction if bumped on either side
        current_state <= ~current_state;
      end
    end
  end

endmodule