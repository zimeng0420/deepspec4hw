module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	input dig,
	output reg walk_left,
	output reg walk_right,
	output reg aaah,
	output reg digging
);

    typedef enum reg [1:0] {
        STATE_WALK_LEFT,
        STATE_WALK_RIGHT,
        STATE_FALL,
        STATE_DIG
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
        // Default assignments
        next_state = current_state;
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (current_state)
            STATE_WALK_LEFT: begin
                walk_left = 1;
                if (!ground) begin
                    next_state = STATE_FALL;
                    aaah = 1;
                end else if (bump_right) begin
                    next_state = STATE_WALK_RIGHT;
                end else if (dig) begin
                    next_state = STATE_DIG;
                end
            end

            STATE_WALK_RIGHT: begin
                walk_right = 1;
                if (!ground) begin
                    next_state = STATE_FALL;
                    aaah = 1;
                end else if (bump_left) begin
                    next_state = STATE_WALK_LEFT;
                end else if (dig) begin
                    next_state = STATE_DIG;
                end
            end

            STATE_FALL: begin
                aaah = 1;
                if (ground) begin
                    if (current_state == STATE_WALK_LEFT) begin
                        next_state = STATE_WALK_LEFT;
                    end else if (current_state == STATE_WALK_RIGHT) begin
                        next_state = STATE_WALK_RIGHT;
                    end
                end
            end

            STATE_DIG: begin
                digging = 1;
                if (!ground) begin
                    next_state = STATE_FALL;
                    aaah = 1;
                end else if (ground && !dig) begin
                    if (current_state == STATE_WALK_LEFT) begin
                        next_state = STATE_WALK_LEFT;
                    end else if (current_state == STATE_WALK_RIGHT) begin
                        next_state = STATE_WALK_RIGHT;
                    end
                end
            end

            default: begin
                next_state = STATE_WALK_LEFT;
            end
        endcase
    end
endmodule