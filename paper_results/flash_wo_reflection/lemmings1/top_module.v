module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

  reg current_state;
  parameter WALK_LEFT = 1'b1;
  parameter WALK_RIGHT = 1'b0;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= WALK_LEFT;
    end else begin
      if (bump_left | bump_right) begin
        current_state <= ~current_state;
      end
    end
  end

  assign walk_left = current_state;
  assign walk_right = ~current_state;

endmodule