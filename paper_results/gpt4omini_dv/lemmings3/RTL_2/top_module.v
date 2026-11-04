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
        WALK_LEFT = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING = 2'b10,
        DIGGING = 2'b11
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) 
            state <= WALK_LEFT;
        else 
            state <= next_state;
    end

    always_ff @(state or bump_left or bump_right or ground or dig) begin
        // Default outputs
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        
        case (state)
            WALK_LEFT: begin
                walk_left = 1;
                if (~ground) 
                    next_state = FALLING;
                else if (dig) 
                    next_state = DIGGING;
                else if (bump_right) 
                    next_state = WALK_RIGHT;
                else 
                    next_state = WALK_LEFT;
            end
            
            WALK_RIGHT: begin
                walk_right = 1;
                if (~ground) 
                    next_state = FALLING;
                else if (dig) 
                    next_state = DIGGING;
                else if (bump_left) 
                    next_state = WALK_LEFT;
                else 
                    next_state = WALK_RIGHT;
            end
            
            FALLING: begin
                aaah = 1;
                if (ground) 
                    next_state = (walk_left ? WALK_LEFT : WALK_RIGHT);
                else 
                    next_state = FALLING;
            end
            
            DIGGING: begin
                digging = 1;
                if (~ground) 
                    next_state = FALLING; 
                else 
                    next_state = DIGGING;
            end
            
            default: next_state = WALK_LEFT; // Default case
        endcase
    end
endmodule