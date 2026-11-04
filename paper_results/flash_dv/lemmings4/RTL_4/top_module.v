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

    // Define states
    typedef enum logic [2:0] {
        WALK_LEFT,
        WALK_RIGHT,
        FALLING,
        DIGGING,
        SPLAT
    } state_t;

    // State register
    state_t current_state, next_state;

    // Falling counter
    logic [4:0] fall_counter, next_fall_counter;

    // Previous direction before falling
    typedef enum logic {LEFT, RIGHT} direction_t;
    direction_t previous_direction, next_previous_direction;

    // State update logic
    always_ff @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            fall_counter <= 0;
            previous_direction <= LEFT;
        end else begin
            current_state <= next_state;
            fall_counter <= next_fall_counter;
            previous_direction <= next_previous_direction;
        end
    end

    // Next state and counter logic
    always_comb begin
        next_state = current_state;
        next_fall_counter = fall_counter;
        next_previous_direction = previous_direction;

        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                    next_fall_counter = 0;
                    next_previous_direction = LEFT;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                    next_fall_counter = 0;
                    next_previous_direction = RIGHT;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_right || bump_left) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (fall_counter >= 20) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = (previous_direction == LEFT) ? WALK_LEFT : WALK_RIGHT;
                    end
                    next_fall_counter = 0;
                } else begin
                    next_state = FALLING;
                    next_fall_counter = fall_counter + 1;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                    next_fall_counter = 0;
                end else begin
                    next_state = DIGGING;
                end
            end
            SPLAT: begin
                next_state = SPLAT;
                next_fall_counter = 0;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic
    assign walk_left = (current_state == WALK_LEFT);
    assign walk_right = (current_state == WALK_RIGHT);
    assign aaah = (current_state == FALLING);
    assign digging = (current_state == DIGGING);

endmodule