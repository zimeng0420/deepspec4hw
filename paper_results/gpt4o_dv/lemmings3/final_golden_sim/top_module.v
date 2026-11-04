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
    typedef enum reg [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10,
        DIGGING    = 2'b11
    } state_t;

    state_t state, next_state;
    state_t prev_walk_state; // To remember walking direction before falling or digging

    // Sequential logic for state transitions
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            prev_walk_state <= WALK_LEFT;
        end else begin
            state <= next_state;
            if (state == WALK_LEFT || state == WALK_RIGHT)
                prev_walk_state <= state;
        end
    end
    
    // Combinational logic for next state
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground) 
                    next_state = FALLING;
                else if (dig) 
                    next_state = DIGGING;
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALLING;
                else if (dig)
                    next_state = DIGGING;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            FALLING: begin
                if (ground)
                    next_state = prev_walk_state;
                else
                    next_state = FALLING;
            end
            DIGGING: begin
                if (!ground)
                    next_state = FALLING;
                else
                    next_state = DIGGING;
            end
            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Output logic
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);
    assign walk_left = (state == WALK_LEFT && !aaah && !digging);
    assign walk_right = (state == WALK_RIGHT && !aaah && !digging);

endmodule