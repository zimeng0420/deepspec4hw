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

    typedef enum logic [1:0] {
        WALK_LEFT = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING = 2'b10
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) 
            current_state <= WALK_LEFT;
        else 
            current_state <= next_state;
    end

    always_ff @(current_state or bump_left or bump_right or ground) begin
        case (current_state)
            WALK_LEFT: begin
                walk_left <= 1;
                walk_right <= 0;
                aaah <= (ground == 0);
                if (bump_right)
                    next_state = WALK_RIGHT;
                else if (!ground)
                    next_state = FALLING;
                else
                    next_state = WALK_LEFT;
            end

            WALK_RIGHT: begin
                walk_left <= 0;
                walk_right <= 1;
                aaah <= (ground == 0);
                if (bump_left)
                    next_state = WALK_LEFT;
                else if (!ground)
                    next_state = FALLING;
                else
                    next_state = WALK_RIGHT;
            end

            FALLING: begin
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 1;
                if (ground) 
                    next_state = (walk_left ? WALK_LEFT : WALK_RIGHT);
                else
                    next_state = FALLING;
            end
        endcase
    end

endmodule