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

  // State definition
  localparam LEFT = 2'b00;
  localparam RIGHT = 2'b01;
  localparam FALLING = 2'b10;

  // State variable
  reg [1:0] current_state;
  reg [1:0] next_state;
  reg [1:0] previous_state; // Store state before falling

  // Output assignments (Moore machine)
  assign walk_left = (current_state == LEFT) & ground;
  assign walk_right = (current_state == RIGHT) & ground;
  assign aaah = (current_state == FALLING);

  // State transition logic
  always @(*) begin
    case (current_state)
      LEFT: begin
        if (!ground) begin
          next_state = FALLING;
        end else if (bump_left || bump_right) begin
          next_state = RIGHT;
        end else begin
          next_state = LEFT;
        end
      end
      RIGHT: begin
        if (!ground) begin
          next_state = FALLING;
        end else if (bump_left || bump_right) begin
          next_state = LEFT;
        end else begin
          next_state = RIGHT;
        end
      end
      FALLING: begin
        if (ground) begin
          if (bump_left || bump_right) begin
              next_state = LEFT;
          end else begin
              next_state = previous_state;
          end
        end else begin
          next_state = FALLING;
        end
      end
      default: next_state = LEFT; // Default state
    endcase
  end

  // State update logic
  always_ff @(posedge clk, posedge areset) begin
    if (areset) begin
      current_state <= LEFT;
      previous_state <= LEFT;
    end else begin
      if (current_state != FALLING && !ground) begin
        previous_state <= current_state;
      end
      current_state <= next_state;
    end
  end

endmodule