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
        STATE_WALK_LEFT = 2'b00,
        STATE_WALK_RIGHT = 2'b01,
        STATE_FALLING = 2'b10,
        STATE_DIGGING = 2'b11
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
        // Default outputs
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        
        case (current_state)
            STATE_WALK_LEFT: begin
                if (!ground) begin
                    aaah = 1;
                    next_state = STATE_FALLING;
                end else if (dig) begin
                    digging = 1;
                    next_state = STATE_DIGGING;
                end else if (bump_right) begin
                    walk_right = 1;
                    next_state = STATE_WALK_RIGHT;
                end else begin
                    walk_left = 1;
                    next_state = STATE_WALK_LEFT;
                end
            end
            
            STATE_WALK_RIGHT: begin
                if (!ground) begin
                    aaah = 1;
                    next_state = STATE_FALLING;
                end else if (dig) begin
                    digging = 1;
                    next_state = STATE_DIGGING;
                end else if (bump_left) begin
                    walk_left = 1;
                    next_state = STATE_WALK_LEFT;
                end else begin
                    walk_right = 1;
                    next_state = STATE_WALK_RIGHT;
                end
            end
            
            STATE_FALLING: begin
                if (ground) begin
                    if (walk_left) begin
                        walk_left = 1;
                    end else if (walk_right) begin
                        walk_right = 1;
                    end
                    next_state = (walk_left) ? STATE_WALK_LEFT : STATE_WALK_RIGHT;
                end else begin
                    aaah = 1;
                    next_state = STATE_FALLING;
                end
            end
            
            STATE_DIGGING: begin
                if (!ground) begin
                    aaah = 1;
                    next_state = STATE_FALLING;
                end else begin
                    digging = 1;
                    next_state = STATE_DIGGING;
                end
            end
            
            default: next_state = STATE_WALK_LEFT;
        endcase
    end
endmodule