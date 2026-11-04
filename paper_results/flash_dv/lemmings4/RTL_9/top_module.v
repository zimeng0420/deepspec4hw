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
    logic [2:0] current_state, next_state;

    // Falling counter
    logic [4:0] fall_counter, next_fall_counter;

    // Internal signal to store previous direction before falling
    typedef enum logic {
        LEFT,
        RIGHT
    } direction_t;
    direction_t previous_direction, next_previous_direction;

    // Output signals
    assign walk_left = (current_state == WALK_LEFT) && (current_state != SPLAT);
    assign walk_right = (current_state == WALK_RIGHT) && (current_state != SPLAT);
    assign aaah = (current_state == FALLING) && (current_state != SPLAT);
    assign digging = (current_state == DIGGING) && (current_state != SPLAT);

    // Next state logic
    always_comb begin
        next_state = current_state;
        next_fall_counter = fall_counter;
        next_previous_direction = previous_direction;

        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                    next_previous_direction = LEFT;
                end else if (dig) begin
                    next_state = DIGGING;
                    next_previous_direction = LEFT;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_RIGHT;
                    next_previous_direction = RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                    next_previous_direction = LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                    next_previous_direction = RIGHT;
                end else if (dig) begin
                    next_state = DIGGING;
                    next_previous_direction = RIGHT;
                end else if (bump_right || bump_left) begin
                    next_state = WALK_LEFT;
                    next_previous_direction = LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                    next_previous_direction = RIGHT;
                end
            end
            FALLING: begin
                if (ground && (fall_counter >= 20)) begin
                    next_state = SPLAT;
                end else if (ground && (fall_counter < 20)) begin
                    next_state = (previous_direction == LEFT) ? WALK_LEFT : WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                    next_fall_counter = fall_counter + 1;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                    next_previous_direction = (current_state == WALK_LEFT) ? LEFT : RIGHT;
                end else begin
                    next_state = DIGGING;
                end
            end
            SPLAT: begin
                next_state = SPLAT;
            end
            default: begin
                next_state = WALK_LEFT;
                next_previous_direction = LEFT;
            end
        endcase
    end

    // Sequential logic
    always_ff @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            fall_counter <= 0;
            previous_direction <= LEFT;
        end else begin
            current_state <= next_state;
            fall_counter <= (next_state == FALLING) ? next_fall_counter : (ground ? 0 : fall_counter);
            previous_direction <= next_previous_direction;
        end
    end

endmodule