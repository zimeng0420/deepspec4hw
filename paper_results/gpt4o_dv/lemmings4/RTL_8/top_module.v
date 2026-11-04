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

    typedef enum reg [2:0] {
        STATE_WALK_LEFT,
        STATE_WALK_RIGHT,
        STATE_FALL,
        STATE_DIG_LEFT,
        STATE_DIG_RIGHT,
        STATE_SPLATTER
    } state_t;

    state_t current_state, next_state;
    reg [4:0] fall_counter;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_WALK_LEFT;
            fall_counter <= 0;
        end else begin
            current_state <= next_state;

            if (current_state == STATE_FALL) begin
                fall_counter <= fall_counter + 1;
            end else if (ground) begin
                fall_counter <= 0;
            end
        end
    end

    always @(*) begin
        // Default outputs
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (current_state)
            STATE_WALK_LEFT: begin
                if (!ground) begin
                    next_state = STATE_FALL;
                    aaah = 1;
                end else if (dig) begin
                    next_state = STATE_DIG_LEFT;
                    digging = 1;
                end else if (bump_left) begin
                    next_state = STATE_WALK_RIGHT;
                    walk_right = 1;
                end else begin
                    next_state = STATE_WALK_LEFT;
                    walk_left = 1;
                end
            end

            STATE_WALK_RIGHT: begin
                if (!ground) begin
                    next_state = STATE_FALL;
                    aaah = 1;
                end else if (dig) begin
                    next_state = STATE_DIG_RIGHT;
                    digging = 1;
                end else if (bump_right) begin
                    next_state = STATE_WALK_LEFT;
                    walk_left = 1;
                end else begin
                    next_state = STATE_WALK_RIGHT;
                    walk_right = 1;
                end
            end

            STATE_FALL: begin
                aaah = 1;
                if (ground) begin
                    if (fall_counter > 5'd20) begin
                        next_state = STATE_SPLATTER;
                    end else if (current_state == STATE_WALK_LEFT || current_state == STATE_DIG_LEFT) begin
                        next_state = STATE_WALK_LEFT;
                        walk_left = 1;
                    end else if (current_state == STATE_WALK_RIGHT || current_state == STATE_DIG_RIGHT) begin
                        next_state = STATE_WALK_RIGHT;
                        walk_right = 1;
                    end
                end else begin
                    next_state = STATE_FALL;
                end
            end

            STATE_DIG_LEFT: begin
                if (!ground) begin
                    next_state = STATE_FALL;
                    aaah = 1;
                end else begin
                    next_state = STATE_DIG_LEFT;
                    digging = 1;
                end
            end

            STATE_DIG_RIGHT: begin
                if (!ground) begin
                    next_state = STATE_FALL;
                    aaah = 1;
                end else begin
                    next_state = STATE_DIG_RIGHT;
                    digging = 1;
                end
            end

            STATE_SPLATTER: begin
                next_state = STATE_SPLATTER;
            end
        endcase
    end

endmodule