module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // State Encoding
    typedef enum logic {WALK_LEFT, WALK_RIGHT} state_t;
    state_t state, next_state;

    // State Transition
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT; // Asynchronous reset to WALK_LEFT
        end else begin
            state <= next_state;
        end
    end

    // Next State Logic
    always_comb begin
        case (state)
            WALK_LEFT: begin
                if (bump_left) begin
                    next_state = WALK_RIGHT; // Bumped left, walk right
                end else if (bump_right) begin
                    next_state = WALK_LEFT;  // Bumped right, stay left
                end else begin
                    next_state = WALK_LEFT;  // Continue walking left
                end
            end

            WALK_RIGHT: begin
                if (bump_right) begin
                    next_state = WALK_LEFT;  // Bumped right, walk left
                end else if (bump_left) begin
                    next_state = WALK_RIGHT; // Bumped left, stay right
                end else begin
                    next_state = WALK_RIGHT; // Continue walking right
                end
            end

            default: next_state = WALK_LEFT; // Default case
        endcase
    end

    // Output Logic
    always_comb begin
        walk_left = (state == WALK_LEFT);
        walk_right = (state == WALK_RIGHT);
    end

endmodule