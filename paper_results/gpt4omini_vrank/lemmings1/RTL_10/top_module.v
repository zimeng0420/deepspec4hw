module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    typedef enum logic [1:0] {
        STATE_WALK_LEFT = 2'b00,
        STATE_WALK_RIGHT = 2'b01
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    always_ff @(state or bump_left or bump_right) begin
        case (state)
            STATE_WALK_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                if (bump_right)
                    next_state = STATE_WALK_RIGHT;
                else
                    next_state = STATE_WALK_LEFT;
            end

            STATE_WALK_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                if (bump_left)
                    next_state = STATE_WALK_LEFT;
                else
                    next_state = STATE_WALK_RIGHT;
            end

            default: begin
                walk_left = 0;
                walk_right = 0;
                next_state = STATE_WALK_LEFT;
            end
        endcase
    end

endmodule