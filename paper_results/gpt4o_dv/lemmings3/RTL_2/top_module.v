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

    // Define state encoding
    typedef enum logic [1:0] {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING} state_t;
    state_t state, next_state;

    // Output Logic: Outputs depend only on the current state (Moore machine)
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

    // State Transition Logic: Determine next state
    always_comb begin
        case (state)
            WALK_LEFT: begin
                if (~ground)
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end

            WALK_RIGHT: begin
                if (~ground)
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end

            FALLING: begin
                if (ground)
                    next_state = state == WALK_LEFT ? WALK_LEFT : WALK_RIGHT;
                else
                    next_state = FALLING;
            end

            DIGGING: begin
                if (~ground)
                    next_state = FALLING;
                else
                    next_state = DIGGING;
            end

            default: next_state = WALK_LEFT; // Default safe state
        endcase
    end

    // State Register with Asynchronous Reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;  // Reset to walking left
        else
            state <= next_state; // State transitions on clock edge
    end

endmodule