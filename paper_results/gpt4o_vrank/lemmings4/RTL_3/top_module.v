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
    typedef enum logic [3:0] {
        WALK_LEFT  = 4'b0001,
        WALK_RIGHT = 4'b0010,
        FALL_LEFT  = 4'b0100,
        FALL_RIGHT = 4'b1000,
        DIG_LEFT   = 4'b0011,
        DIG_RIGHT  = 4'b0110,
        SPLATTERED = 4'b1111
    } state_t;
    
    state_t state, next_state;
    logic [4:0] fall_count;

    // State transition logic
    always @(*) begin
        next_state = state; // Default to no state change

        case (state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALL_LEFT;
                else if (dig)
                    next_state = DIG_LEFT;
                else if (bump_left)
                    next_state = WALK_RIGHT;
            end
            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALL_RIGHT;
                else if (dig)
                    next_state = DIG_RIGHT;
                else if (bump_right)
                    next_state = WALK_LEFT;
            end
            FALL_LEFT: begin
                if (ground && (fall_count > 20))
                    next_state = SPLATTERED;
                else if (ground && (fall_count <= 20))
                    next_state = WALK_LEFT;
            end
            FALL_RIGHT: begin
                if (ground && (fall_count > 20))
                    next_state = SPLATTERED;
                else if (ground && (fall_count <= 20))
                    next_state = WALK_RIGHT;
            end
            DIG_LEFT: begin
                if (!ground)
                    next_state = FALL_LEFT;
            end
            DIG_RIGHT: begin
                if (!ground)
                    next_state = FALL_RIGHT;
            end
            SPLATTERED: begin
                // Stay in this state forever
            end
        endcase
    end

    // State register and fall count logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 0;
        end
        else begin
            state <= next_state;
            if (!ground || state == FALL_LEFT || state == FALL_RIGHT)
                fall_count <= fall_count + 1;
            else
                fall_count <= 0;
        end
    end

    // Output logic
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule