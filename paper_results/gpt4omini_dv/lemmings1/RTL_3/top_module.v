module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    typedef enum logic {WALK_LEFT, WALK_RIGHT} state_t;
    state_t current_state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= WALK_LEFT;
        else
            current_state <= next_state;
    end

    always_comb begin
        case (current_state)
            WALK_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                if (bump_left)
                    next_state = WALK_RIGHT;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_LEFT;
            end
            
            WALK_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                if (bump_right)
                    next_state = WALK_LEFT;
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_RIGHT;
            end
            
            default: begin
                walk_left = 0;
                walk_right = 0;
                next_state = WALK_LEFT; // Default state
            end
        endcase
    end

endmodule