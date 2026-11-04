module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

  // Define the states
  localparam WALK_LEFT  = 1'b0;
  localparam WALK_RIGHT = 1'b1;

  // State register
  reg current_state;

  // Output assignments (Moore machine)
  assign walk_left  = (current_state == WALK_LEFT);
  assign walk_right = (current_state == WALK_RIGHT);

  // State transition logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= WALK_LEFT;
    end else begin
      case (current_state)
        WALK_LEFT: begin
          if (bump_left || bump_right) begin
            current_state <= WALK_RIGHT;
          end else begin
            current_state <= WALK_LEFT;
          end
        end
        WALK_RIGHT: begin
          if (bump_left || bump_right) begin
            current_state <= WALK_LEFT;
          end else begin
            current_state <= WALK_RIGHT;
          end
        end
        default: current_state <= WALK_LEFT; // Should never happen, but good practice
      endcase
    end
  end

endmodule