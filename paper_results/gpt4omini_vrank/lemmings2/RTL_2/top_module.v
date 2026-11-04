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
        STATE_WALK_LEFT,
        STATE_WALK_RIGHT,
        STATE_FALL
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    always_ff @(state or bump_left or bump_right or ground) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        next_state = state;

        case (state)
            STATE_WALK_LEFT: begin
                walk_left = 1;
                if (bump_right) begin
                    next_state = STATE_WALK_RIGHT;
                end else if (!ground) begin
                    next_state = STATE_FALL;
                    aaah = 1;
                end
            end

            STATE_WALK_RIGHT: begin
                walk_right = 1;
                if (bump_left) begin
                    next_state = STATE_WALK_LEFT;
                end else if (!ground) begin
                    next_state = STATE_FALL;
                    aaah = 1;
                end
            end

            STATE_FALL: begin
                if (ground) begin
                    if (state == STATE_WALK_LEFT) begin
                        next_state = STATE_WALK_LEFT;
                    end else begin
                        next_state = STATE_WALK_RIGHT;
                    end
                end
            end
        endcase
    end

endmodule