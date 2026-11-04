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

    // State definition
    typedef enum {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING, SPLAT} state_t;
    reg state_t current_state, next_state;

    // Fall counter
    reg [4:0] fall_counter;

    // Previous direction
    typedef enum {LEFT, RIGHT} direction_t;
    reg direction_t previous_direction;

    // Output signals
    assign walk_left = (current_state == WALK_LEFT) && (current_state != SPLAT);
    assign walk_right = (current_state == WALK_RIGHT) && (current_state != SPLAT);
    assign aaah = (current_state == FALLING) && (current_state != SPLAT);
    assign digging = (current_state == DIGGING) && (current_state != SPLAT);

    // Next state logic
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_RIGHT;
                    previous_direction = RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                    previous_direction = LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_right || bump_left) begin
                    next_state = WALK_LEFT;
                    previous_direction = LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                    previous_direction = RIGHT;
                end
            end
            FALLING: begin
                if (ground && (fall_counter >= 20)) begin
                    next_state = SPLAT;
                end else if (ground) begin
                    next_state = (previous_direction == LEFT) ? WALK_LEFT : WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                end else begin
                    next_state = DIGGING;
                end
            end
            SPLAT: begin
                next_state = SPLAT;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            fall_counter <= 0;
            previous_direction <= LEFT;
        end else begin
            current_state <= next_state;
            if (!ground) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

endmodule