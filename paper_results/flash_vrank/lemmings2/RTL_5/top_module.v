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
    localparam WALK_LEFT = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING = 2'b10;

    // State register
    reg [1:0] current_state;
    reg [1:0] next_state;

    // Walking direction register (to remember direction before falling)
    reg walking_direction; // 0: left, 1: right

    // Output signals
    assign walk_left = (current_state == WALK_LEFT) || ((current_state != FALLING) && (walking_direction == 0) && (current_state == WALK_RIGHT));
    assign walk_right = (current_state == WALK_RIGHT) || ((current_state != FALLING) && (walking_direction == 1) && (current_state == WALK_LEFT));
    assign aaah = (current_state == FALLING);

    // State transition logic
    always @(*) begin
        next_state = current_state; // Default: stay in the same state

        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                    walking_direction = 0; // Remember walking left
                end else if (bump_left || bump_right) begin
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                    walking_direction = 1; // Remember walking right
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end
            end
            FALLING: begin
                if (ground) begin
                   if (walking_direction == 0) begin
                      next_state = WALK_LEFT;
                   end else begin
                      next_state = WALK_RIGHT;
                   end
                end
            end
            default: next_state = WALK_LEFT; // Should not happen, but good to have a default
        endcase
    end

    // State update logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            walking_direction <= 0; // initialize direction to left
        end else begin
            current_state <= next_state;
        end
    end

endmodule