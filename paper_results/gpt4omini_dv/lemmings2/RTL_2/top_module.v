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

    typedef enum reg [1:0] {
        STATE_WALK_LEFT = 2'b00,
        STATE_WALK_RIGHT = 2'b01,
        STATE_FALLING = 2'b10
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_WALK_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;

        case (current_state)
            STATE_WALK_LEFT: begin
                if (ground == 0) begin
                    aaah = 1;
                    next_state = STATE_FALLING;
                end else if (bump_right) begin
                    walk_right = 1;
                    next_state = STATE_WALK_RIGHT;
                end else begin
                    walk_left = 1;
                    next_state = STATE_WALK_LEFT;
                end
            end
            STATE_WALK_RIGHT: begin
                if (ground == 0) begin
                    aaah = 1;
                    next_state = STATE_FALLING;
                end else if (bump_left) begin
                    walk_left = 1;
                    next_state = STATE_WALK_LEFT;
                end else begin
                    walk_right = 1;
                    next_state = STATE_WALK_RIGHT;
                end
            end
            STATE_FALLING: begin
                aaah = 1;
                if (ground == 1) begin
                    if (walk_left) begin
                        next_state = STATE_WALK_LEFT;
                        walk_left = 1;
                    end else if (walk_right) begin
                        next_state = STATE_WALK_RIGHT;
                        walk_right = 1;
                    end
                end else begin
                    next_state = STATE_FALLING;
                end
            end
            default: begin
                next_state = STATE_WALK_LEFT;
            end
        endcase
    end

endmodule