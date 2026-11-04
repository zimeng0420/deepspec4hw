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
        WALKING_LEFT,
        WALKING_RIGHT,
        FALLING,
        DIGGING
    } state_t;

    // State register
    state_t current_state, next_state;

    // State transition logic
    always_ff @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= WALKING_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        next_state = current_state; // Default: stay in the same state

        case (current_state)
            WALKING_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left || bump_right) begin
                    next_state = WALKING_RIGHT;
                end
            end
            WALKING_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left || bump_right) begin
                    next_state = WALKING_LEFT;
                end
            end
            FALLING: begin
                if (ground) begin
                    // Resume walking in the same direction as before the fall
                    if (current_state == FALLING) begin
                        if (next_state == WALKING_LEFT)
                            next_state = WALKING_LEFT;
                        else
                            next_state = WALKING_RIGHT;
                    end
                    else
                        next_state = current_state;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                end
            end
            default: next_state = WALKING_LEFT;
        endcase
    end

    // Output logic (Moore machine)
    assign aaah = (current_state == FALLING);
    assign digging = (current_state == DIGGING);
    assign walk_left = (current_state == WALKING_LEFT) && (current_state != FALLING) && (current_state != DIGGING);
    assign walk_right = (current_state == WALKING_RIGHT) && (current_state != FALLING) && (current_state != DIGGING);

endmodule