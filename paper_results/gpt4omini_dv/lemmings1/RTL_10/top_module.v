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
        if (areset) begin
            current_state <= WALK_LEFT; // Asynchronous reset to WALK_LEFT
        end else begin
            current_state <= next_state; // State transition on clock edge
        end
    end

    always_ff @(current_state or bump_left or bump_right) begin
        case (current_state)
            WALK_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                if (bump_left) begin
                    next_state = WALK_RIGHT; // Transition to WALK_RIGHT on bump_left
                end else if (bump_right) begin
                    next_state = WALK_RIGHT; // Transition to WALK_RIGHT on bump_right
                end else begin
                    next_state = WALK_LEFT; // Stay in WALK_LEFT
                end
            end

            WALK_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                if (bump_left) begin
                    next_state = WALK_LEFT; // Transition to WALK_LEFT on bump_left
                end else if (bump_right) begin
                    next_state = WALK_LEFT; // Transition to WALK_LEFT on bump_right
                end else begin
                    next_state = WALK_RIGHT; // Stay in WALK_RIGHT
                end
            end
        endcase
    end
endmodule