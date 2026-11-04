module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    typedef enum logic [1:0] {LEFT, RIGHT} state_t;
    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= LEFT;  // On reset, go to LEFT state
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            LEFT: begin
                if (bump_left || (bump_left && bump_right))
                    next_state = RIGHT;   // Switch to RIGHT
                else
                    next_state = LEFT;    // Stay in LEFT
            end
            RIGHT: begin
                if (bump_right || (bump_left && bump_right))
                    next_state = LEFT;    // Switch to LEFT
                else
                    next_state = RIGHT;   // Stay in RIGHT
            end
        endcase
    end

    // Output logic
    assign walk_left = (current_state == LEFT);
    assign walk_right = (current_state == RIGHT);

endmodule