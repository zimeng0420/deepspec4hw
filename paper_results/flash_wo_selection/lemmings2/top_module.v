module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

  reg walk_left_r;
  reg walk_right_r;
  reg falling;

  assign walk_left = walk_left_r;
  assign walk_right = walk_right_r;
  assign aaah = falling;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      walk_left_r <= 1'b1;
      walk_right_r <= 1'b0;
      falling <= 1'b0;
    end else begin
      if (!ground) begin
        falling <= 1'b1;
      end else begin
        falling <= 1'b0;
      end

      if (!falling) begin
        if (bump_left || bump_right) begin
          walk_left_r <= walk_right_r;
          walk_right_r <= walk_left_r;
        end
      end
    end
  end

endmodule