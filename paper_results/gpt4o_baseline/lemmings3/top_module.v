module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding
    typedef enum logic [2:0] {
        WALK_LEFT   = 3'b000,
        WALK_RIGHT  = 3'b001,
        FALL        = 3'b010,
        DIG_LEFT    = 3'b011,
        DIG_RIGHT   = 3'b100
    } state_t;
    
    state_t current_state, next_state;

    // State transitions
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALL;
                else if (dig)
                    next_state = DIG_LEFT;
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALL;
                else if (dig)
                    next_state = DIG_RIGHT;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            FALL: begin
                if (ground)
                    next_state = (current_state == WALK_LEFT || current_state == DIG_LEFT) ? WALK_LEFT : WALK_RIGHT;
                else
                    next_state = FALL;
            end
            DIG_LEFT: begin
                if (!ground)
                    next_state = FALL;
                else
                    next_state = DIG_LEFT;
            end
            DIG_RIGHT: begin
                if (!ground)
                    next_state = FALL;
                else
                    next_state = DIG_RIGHT;
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= WALK_LEFT;
        else
            current_state <= next_state;
    end

    // Output logic
    assign walk_left = (current_state == WALK_LEFT);
    assign walk_right = (current_state == WALK_RIGHT);
    assign aaah = (current_state == FALL);
    assign digging = (current_state == DIG_LEFT || current_state == DIG_RIGHT);

endmodule