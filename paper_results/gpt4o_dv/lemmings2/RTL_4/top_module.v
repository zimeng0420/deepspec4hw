module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    typedef enum reg [1:0] {ST_WALK_LEFT, ST_WALK_RIGHT, ST_FALLING} state_t;
    state_t state, next_state;
    
    // State transition
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= ST_WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end
    
    // Next state logic
    always @(*) begin
        case (state)
            ST_WALK_LEFT: begin
                if (~ground)
                    next_state = ST_FALLING;
                else if (bump_left)
                    next_state = ST_WALK_RIGHT;
                else
                    next_state = ST_WALK_LEFT;
            end
            ST_WALK_RIGHT: begin
                if (~ground)
                    next_state = ST_FALLING;
                else if (bump_right)
                    next_state = ST_WALK_LEFT;
                else
                    next_state = ST_WALK_RIGHT;
            end
            ST_FALLING: begin
                if (ground)
                    next_state = (bump_left ? ST_WALK_RIGHT : ST_WALK_LEFT); // Resume the direction before falling
                else
                    next_state = ST_FALLING;
            end
            default: next_state = ST_WALK_LEFT;
        endcase
    end
    
    // Output logic
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        
        case (state)
            ST_WALK_LEFT: begin
                walk_left = 1;
            end
            ST_WALK_RIGHT: begin
                walk_right = 1;
            end
            ST_FALLING: begin
                aaah = 1;
            end
        endcase
    end
    
endmodule