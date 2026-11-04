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

    // State Definitions
    typedef enum logic [1:0] {
        WALK_LEFT,
        WALK_RIGHT,
        FALL
    } state_t;
    
    state_t current_state, next_state;
    state_t last_walk_state; // To remember the last walking direction before falling

    // State Transition Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            last_walk_state <= WALK_LEFT;
        end
        else begin
            current_state <= next_state;
        end
    end

    // Next State Logic
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALL;
                    last_walk_state = WALK_LEFT;
                end
                else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end
                else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL;
                    last_walk_state = WALK_RIGHT;
                end
                else if (bump_right) begin
                    next_state = WALK_LEFT;
                end
                else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALL: begin
                if (ground) begin
                    next_state = last_walk_state;
                end
                else begin
                    next_state = FALL;
                end
            end

            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Output Logic
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
            end
            WALK_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
            end
            FALL: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
            end
            default: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
            end
        endcase
    end

endmodule