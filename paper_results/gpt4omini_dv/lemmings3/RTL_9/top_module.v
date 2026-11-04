module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    // State encoding
    typedef enum logic [1:0] {
        WALK_LEFT   = 2'b00,
        WALK_RIGHT  = 2'b01,
        FALLING     = 2'b10,
        DIGGING     = 2'b11
    } state_t;

    state_t current_state, next_state;

    // Asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT; // Reset to walking left
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        next_state = current_state; // Default to current state
        // Default outputs
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (current_state)
            WALK_LEFT: begin
                walk_left = 1;
                if (!ground) begin
                    next_state = FALLING; // Fall if no ground
                end else if (dig) begin
                    next_state = DIGGING; // Start digging
                end else if (bump_right) begin
                    next_state = WALK_RIGHT; // Bump right
                end
            end

            WALK_RIGHT: begin
                walk_right = 1;
                if (!ground) begin
                    next_state = FALLING; // Fall if no ground
                end else if (dig) begin
                    next_state = DIGGING; // Start digging
                end else if (bump_left) begin
                    next_state = WALK_LEFT; // Bump left
                end
            end

            FALLING: begin
                aaah = 1; // Falling
                if (ground) begin
                    if (current_state == FALLING) begin
                        next_state = (bump_right) ? WALK_LEFT : WALK_RIGHT; // Resume walking in original direction
                    end
                end
            end

            DIGGING: begin
                digging = 1; // Digging
                if (!ground) begin
                    next_state = FALLING; // Fall if no ground after digging
                end
            end
        endcase
    end

endmodule