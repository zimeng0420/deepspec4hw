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

    // Define states
    typedef enum logic [2:0] {
        WALK_LEFT  = 3'd0,
        WALK_RIGHT = 3'd1,
        FALL_LEFT  = 3'd2,
        FALL_RIGHT = 3'd3,
        DIG_LEFT   = 3'd4,
        DIG_RIGHT  = 3'd5
    } state_t;

    // State registers
    state_t state, next_state;

    // Asynchronous reset and state updating logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT; // asynchronous reset to WALK_LEFT
        else
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        // Default next state is current state
        next_state = state;

        case (state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALL_LEFT;
                else if (dig && ground)
                    next_state = DIG_LEFT;
                else if (bump_left || bump_right)
                    next_state = WALK_RIGHT;
            end
            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALL_RIGHT;
                else if (dig && ground)
                    next_state = DIG_RIGHT;
                else if (bump_right || bump_left)
                    next_state = WALK_LEFT;
            end
            FALL_LEFT: begin
                if (ground)
                    next_state = WALK_LEFT;
            end
            FALL_RIGHT: begin
                if (ground)
                    next_state = WALK_RIGHT;
            end
            DIG_LEFT: begin
                if (!ground)
                    next_state = FALL_LEFT;
            end
            DIG_RIGHT: begin
                if (!ground)
                    next_state = FALL_RIGHT;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic based on current state
    always_comb begin
        // Default output values
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (state)
            WALK_LEFT: begin
                walk_left = 1;
            end
            WALK_RIGHT: begin
                walk_right = 1;
            end
            FALL_LEFT, FALL_RIGHT: begin
                aaah = 1;
            end
            DIG_LEFT, DIG_RIGHT: begin
                digging = 1;
            end
        endcase
    end

endmodule