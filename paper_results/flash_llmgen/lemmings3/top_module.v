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

  // Define the states
  localparam WALK_LEFT  = 2'b00;
  localparam WALK_RIGHT = 2'b01;
  localparam FALLING    = 2'b10;
  localparam DIGGING    = 2'b11;

  // State register
  reg [1:0] current_state;
  reg [1:0] next_state;

  // Direction register (stores direction before falling)
  reg walking_direction; // 0: left, 1: right

  // Output registers
  reg r_walk_left;
  reg r_walk_right;
  reg r_aaah;
  reg r_digging;

  // State transition logic
  always @(*) begin
    next_state = current_state; // Default: stay in the same state
    r_aaah = 0; // Default: not falling
    r_digging = 0; // Default: not digging

    case (current_state)
      WALK_LEFT: begin
        if (!ground) begin
          next_state = FALLING;
          r_aaah = 1;
          walking_direction = 0; // Remember direction before falling
        end else if (dig) begin
          next_state = DIGGING;
          r_digging = 1;
        end else if (bump_left || bump_right) begin
          next_state = WALK_RIGHT;
          walking_direction = 1;
        end
      end

      WALK_RIGHT: begin
        if (!ground) begin
          next_state = FALLING;
          r_aaah = 1;
          walking_direction = 1; // Remember direction before falling
        end else if (dig) begin
          next_state = DIGGING;
          r_digging = 1;
        end else if (bump_left || bump_right) begin
          next_state = WALK_LEFT;
          walking_direction = 0;
        end
      end

      FALLING: begin
        r_aaah = 1;
        if (ground) begin
          if (walking_direction == 0) begin
            next_state = WALK_LEFT;
          end else begin
            next_state = WALK_RIGHT;
          end
        end
      end

      DIGGING: begin
        r_digging = 1;
        if (!ground) begin
          next_state = FALLING;
          r_aaah = 1;
        end
      end
    endcase
  end

  // State update logic (sequential)
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= WALK_LEFT;
      walking_direction <= 0;
    end else begin
      current_state <= next_state;
    end
  end

  // Output logic
  always @(*) begin
    r_walk_left = 0;
    r_walk_right = 0;

    case (current_state)
      WALK_LEFT:  r_walk_left  = 1;
      WALK_RIGHT: r_walk_right = 1;
      FALLING:    begin
                    r_walk_left = 0;
                    r_walk_right = 0;
                  end
      DIGGING:    begin
                    r_walk_left = 0;
                    r_walk_right = 0;
                  end
      default: begin
        r_walk_left = 0;
        r_walk_right = 0;
      end
    endcase
  end

  assign walk_left  = r_walk_left;
  assign walk_right = r_walk_right;
  assign aaah       = r_aaah;
  assign digging    = r_digging;

endmodule