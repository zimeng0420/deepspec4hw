module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

  reg current_state; // 0: walk_left, 1: walk_right

  parameter WALK_LEFT = 0;
  parameter WALK_RIGHT = 1;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= WALK_LEFT;
    end else begin
      if (bump_left) begin
        current_state <= WALK_RIGHT;
      end else if (bump_right) begin
        current_state <= WALK_LEFT;
      end
    end
  end

  assign walk_left = (current_state == WALK_LEFT);
  assign walk_right = (current_state == WALK_RIGHT);

endmodule