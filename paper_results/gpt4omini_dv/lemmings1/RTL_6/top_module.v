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

    // Output logic based on state
    always_comb begin
        walk_left = (current_state == WALK_LEFT) ? 1 : 0;
        walk_right = (current_state == WALK_RIGHT) ? 1 : 0;
    end

    // State transition logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
        end else begin
            case (current_state)
                WALK_LEFT: begin
                    if (bump_left) next_state = WALK_RIGHT;
                    else if (bump_right) next_state = WALK_LEFT;
                    else next_state = WALK_LEFT; // stay in state
                end
                WALK_RIGHT: begin
                    if (bump_right) next_state = WALK_LEFT;
                    else if (bump_left) next_state = WALK_RIGHT;
                    else next_state = WALK_RIGHT; // stay in state
                end
                default: next_state = WALK_LEFT; // safe state
            endcase
            current_state <= next_state;
        end
    end

endmodule