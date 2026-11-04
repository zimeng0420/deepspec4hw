module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

  reg walk_left_r;
  reg walk_right_r;
  reg aaah_r;
  reg digging_r;

  assign walk_left = walk_left_r;
  assign walk_right = walk_right_r;
  assign aaah = aaah_r;
  assign digging = digging_r;

  reg current_direction; // 0: left, 1: right

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      walk_left_r <= 1'b1;
      walk_right_r <= 1'b0;
      aaah_r <= 1'b0;
      digging_r <= 1'b0;
      current_direction <= 1'b0;
    end else begin
      aaah_r <= !ground;

      if (ground && dig) begin
        digging_r <= 1'b1;
        walk_left_r <= 1'b0;
        walk_right_r <= 1'b0;
      end else if (!ground) begin
        digging_r <= 1'b0;
        walk_left_r <= 1'b0;
        walk_right_r <= 1'b0;
      end else begin
        digging_r <= 0;
        if (bump_left || bump_right) begin
          current_direction <= ~current_direction;
        end

        walk_left_r <= !current_direction;
        walk_right_r <= current_direction;
      end
    end
  end

endmodule