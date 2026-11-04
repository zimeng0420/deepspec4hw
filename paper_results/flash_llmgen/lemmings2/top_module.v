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

  // Define the states
  localparam IDLE       = 2'b00;
  localparam WALK_LEFT  = 2'b01;
  localparam WALK_RIGHT = 2'b10;
  localparam FALLING    = 2'b11;

  // State register
  reg [1:0] current_state;
  reg [1:0] next_state;
  reg [1:0] prev_state;

  // State transition logic
  always @(*) begin
    case (current_state)
      IDLE: begin
        next_state = WALK_LEFT; // Always starts walking left
      end
      WALK_LEFT: begin
        if (!ground) begin
          next_state = FALLING;
        end else if (bump_right) begin
          next_state = WALK_RIGHT;
        end else begin
          next_state = WALK_LEFT;
        end
      end
      WALK_RIGHT: begin
        if (!ground) begin
          next_state = FALLING;
        end else if (bump_left) begin
          next_state = WALK_LEFT;
        end else begin
          next_state = WALK_RIGHT;
        end
      end
      FALLING: begin
        if (ground) begin
          next_state = prev_state;
        end else begin
          next_state = FALLING;
        end
      end
      default: begin
        next_state = IDLE;
      end
    endcase
  end

  // State update logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= IDLE;
      prev_state <= WALK_LEFT;
    end else begin
      if (current_state != FALLING)
        prev_state <= current_state;
      current_state <= next_state;
    end
  end

  // Output logic (Moore machine)
  assign walk_left  = (current_state == WALK_LEFT);
  assign walk_right = (current_state == WALK_RIGHT);
  assign aaah       = (current_state == FALLING);

endmodule