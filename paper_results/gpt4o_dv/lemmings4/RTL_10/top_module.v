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
        STATE_WALK_LEFT   = 3'b000,
        STATE_WALK_RIGHT  = 3'b001,
        STATE_FALL_LEFT   = 3'b010,
        STATE_FALL_RIGHT  = 3'b011,
        STATE_DIG_LEFT    = 3'b100,
        STATE_DIG_RIGHT   = 3'b101,
        STATE_SPLATTERED  = 3'b110
    } state_t;

    reg [4:0] fall_cnt;
    reg [2:0] state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_WALK_LEFT;
            fall_cnt <= 0;
        end else begin
            state <= next_state;
            if (state == STATE_FALL_LEFT || state == STATE_FALL_RIGHT)
                fall_cnt <= fall_cnt + 1;
            else
                fall_cnt <= 0;
        end
    end

    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        next_state = state;

        case (state)
            STATE_WALK_LEFT: begin
                if (!ground)
                    next_state = STATE_FALL_LEFT;
                else if (dig)
                    next_state = STATE_DIG_LEFT;
                else if (bump_left)
                    next_state = STATE_WALK_RIGHT;
                else
                    walk_left = 1;
            end
            
            STATE_WALK_RIGHT: begin
                if (!ground)
                    next_state = STATE_FALL_RIGHT;
                else if (dig)
                    next_state = STATE_DIG_RIGHT;
                else if (bump_right)
                    next_state = STATE_WALK_LEFT;
                else
                    walk_right = 1;
            end

            STATE_FALL_LEFT, STATE_FALL_RIGHT: begin
                aaah = 1;
                if (ground) begin
                    if (fall_cnt > 20)
                        next_state = STATE_SPLATTERED;
                    else
                        next_state = (state == STATE_FALL_LEFT) ? STATE_WALK_LEFT : STATE_WALK_RIGHT;
                end
            end

            STATE_DIG_LEFT: begin
                digging = 1;
                if (!ground)
                    next_state = STATE_FALL_LEFT;
            end

            STATE_DIG_RIGHT: begin
                digging = 1;
                if (!ground)
                    next_state = STATE_FALL_RIGHT;
            end

            STATE_SPLATTERED: begin
                // Outputs all zero when splattered.
            end
        endcase
    end
endmodule