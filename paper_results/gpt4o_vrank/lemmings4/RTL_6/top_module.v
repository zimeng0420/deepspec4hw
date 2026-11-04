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
        STATE_FALL_LEFT,
        STATE_FALL_RIGHT,
        STATE_DIG_LEFT,
        STATE_DIG_RIGHT,
        STATE_SPLATTER
    } state_t;
    
    state_t state, next_state;
    reg [4:0] fall_count;

    // State transition logic
    always @(*) begin
        case (state)
            STATE_WALK_LEFT: begin
                if (!ground) begin
                    next_state = STATE_FALL_LEFT;
                end else if (dig) begin
                    next_state = STATE_DIG_LEFT;
                end else if (bump_left) begin
                    next_state = STATE_WALK_RIGHT;
                end else begin
                    next_state = STATE_WALK_LEFT;
                end
            end

            STATE_WALK_RIGHT: begin
                if (!ground) begin
                    next_state = STATE_FALL_RIGHT;
                end else if (dig) begin
                    next_state = STATE_DIG_RIGHT;
                end else if (bump_right) begin
                    next_state = STATE_WALK_LEFT;
                end else begin
                    next_state = STATE_WALK_RIGHT;
                end
            end
            
            STATE_FALL_LEFT, STATE_FALL_RIGHT: begin
                if (ground) begin
                    if (fall_count > 20)
                        next_state = STATE_SPLATTER;
                    else if (state == STATE_FALL_LEFT)
                        next_state = STATE_WALK_LEFT;
                    else
                        next_state = STATE_WALK_RIGHT;
                end else begin
                    next_state = state;
                end
            end
            
            STATE_DIG_LEFT: begin
                if (!ground) begin
                    next_state = STATE_FALL_LEFT;
                end else begin
                    next_state = STATE_DIG_LEFT;
                end
            end
            
            STATE_DIG_RIGHT: begin
                if (!ground) begin
                    next_state = STATE_FALL_RIGHT;
                end else begin
                    next_state = STATE_DIG_RIGHT;
                end
            end
            
            STATE_SPLATTER: begin
                next_state = STATE_SPLATTER;
            end
            
            default: begin
                next_state = STATE_WALK_LEFT;
            end
        endcase
    end

    // State flip-flops with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_WALK_LEFT;
            fall_count <= 0;
        end else begin
            state <= next_state;
            if (state == STATE_FALL_LEFT || state == STATE_FALL_RIGHT)
                fall_count <= fall_count + 1;
            else
                fall_count <= 0;
        end
    end

    // Output logic
    always @(*) begin
        walk_left = (state == STATE_WALK_LEFT);
        walk_right = (state == STATE_WALK_RIGHT);
        aaah = (state == STATE_FALL_LEFT || state == STATE_FALL_RIGHT);
        digging = (state == STATE_DIG_LEFT || state == STATE_DIG_RIGHT);
    end

endmodule