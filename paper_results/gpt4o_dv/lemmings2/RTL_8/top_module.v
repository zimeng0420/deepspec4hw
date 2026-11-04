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

    // Define state encodings
    typedef enum reg [1:0] {
        WALK_LEFT = 2'd0,
        WALK_RIGHT = 2'd1,
        FALLING = 2'd2
    } state_t;

    state_t state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else
            state <= next_state;
    end

    always @(*) begin
        // Default outputs
        walk_left = 0;
        walk_right = 0;
        aaah = 0;

        case (state)
            WALK_LEFT: begin
                walk_left = 1;
                if (~ground)
                    next_state = FALLING;
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end

            WALK_RIGHT: begin
                walk_right = 1;
                if (~ground)
                    next_state = FALLING;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end

            FALLING: begin
                aaah = 1;
                if (ground)
                    next_state = (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
                else
                    next_state = FALLING;
            end

            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end

endmodule