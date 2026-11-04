module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State Definition
    typedef enum logic [1:0] {
        LEFT  = 2'b01,
        RIGHT = 2'b10
    } state_t;

    // Current State Register
    state_t current_state, next_state;

    // State Transition Logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= LEFT; // Asynchronous reset to walk left
        else
            current_state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        case (current_state)
            LEFT: begin
                if (bump_left)
                    next_state = RIGHT;
                else
                    next_state = LEFT;
            end

            RIGHT: begin
                if (bump_right)
                    next_state = LEFT;
                else
                    next_state = RIGHT;
            end

            default: next_state = LEFT; // Default to LEFT, should not happen
        endcase
    end

    // Output Logic
    assign walk_left = (current_state == LEFT);
    assign walk_right = (current_state == RIGHT);

endmodule