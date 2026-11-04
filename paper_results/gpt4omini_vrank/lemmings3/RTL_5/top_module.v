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
    
    // State encoding
    typedef enum reg [1:0] {
        STATE_WALK_LEFT = 2'b00,
        STATE_WALK_RIGHT = 2'b01,
        STATE_FALLING = 2'b10,
        STATE_DIGGING = 2'b11
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        next_state = current_state;
        aaah = 0;
        digging = 0;
        
        case (current_state)
            STATE_WALK_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                if (!ground) begin
                    next_state = STATE_FALLING;
                    aaah = 1;
                end else if (dig) begin
                    next_state = STATE_DIGGING;
                    digging = 1;
                end else if (bump_right) begin
                    next_state = STATE_WALK_RIGHT;
                end
            end
            
            STATE_WALK_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                if (!ground) begin
                    next_state = STATE_FALLING;
                    aaah = 1;
                end else if (dig) begin
                    next_state = STATE_DIGGING;
                    digging = 1;
                end else if (bump_left) begin
                    next_state = STATE_WALK_LEFT;
                end
            end
            
            STATE_FALLING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                if (ground) begin
                    if (current_state == STATE_WALK_LEFT)
                        next_state = STATE_WALK_LEFT;
                    else
                        next_state = STATE_WALK_RIGHT;
                end
            end
            
            STATE_DIGGING: begin
                walk_left = 0;
                walk_right = 0;
                digging = 1;
                if (!ground) begin
                    next_state = STATE_FALLING;
                    aaah = 1;
                end
            end
            
            default: begin
                next_state = STATE_WALK_LEFT;
            end
        endcase
    end

    // State update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_WALK_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

endmodule