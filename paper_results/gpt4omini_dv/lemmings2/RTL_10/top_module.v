module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    typedef enum reg [1:0] {WALK_LEFT, WALK_RIGHT, FALLING} state_t;
    state_t current_state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT; // Reset to walk left
        end else begin
            current_state <= next_state; // Transition to next state
        end
    end

    always @(*) begin
        // Default output values
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        
        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    aaah = 1; // Falling condition
                    next_state = FALLING;
                end else if (bump_right) begin
                    walk_right = 1; // Switch to walk right
                    next_state = WALK_RIGHT;
                end else begin
                    walk_left = 1; // Continue walking left
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    aaah = 1; // Falling condition
                    next_state = FALLING;
                end else if (bump_left) begin
                    walk_left = 1; // Switch to walk left
                    next_state = WALK_LEFT;
                end else begin
                    walk_right = 1; // Continue walking right
                    next_state = WALK_RIGHT;
                end
            end

            FALLING: begin
                aaah = 1; // Stay falling
                if (ground) begin
                    // Resume walking in the previous direction
                    next_state = (walk_left) ? WALK_LEFT : WALK_RIGHT;
                end else begin
                    next_state = FALLING; // Remain falling
                end
            end

            default: begin
                next_state = WALK_LEFT; // Default state
            end
        endcase
    end
endmodule