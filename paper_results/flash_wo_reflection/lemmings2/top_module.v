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

  reg walking_left;
  reg walking_right;
  reg falling;

  assign walk_left = ground & walking_left;
  assign walk_right = ground & walking_right;
  assign aaah = ~ground;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      walking_left <= 1'b1;
      walking_right <= 1'b0;
      falling <= 1'b0;
    end else begin
      if (~ground) begin
        falling <= 1'b1;
      end else begin
        falling <= 1'b0;
        if (bump_left) begin
          walking_left <= 1'b0;
          walking_right <= 1'b1;
        end else if (bump_right) begin
          walking_left <= 1'b1;
          walking_right <= 1'b0;
        end
      end
    end
  end

endmodule