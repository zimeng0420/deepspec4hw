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
    
    // State definitions
    typedef enum reg [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10,
        DIGGING    = 2'b11
    } state_t;
    
    state_t state, next_state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;  // Initial state when areset is asserted
        end else begin
            state <= next_state; // Synchronous state transition
        end
    end

    always @(*) begin
        // Default outputs
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                    walk_right = 1;
                end else begin
                    next_state = WALK_LEFT;
                    walk_left = 1;
                end
            end
            
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                    walk_left = 1;
                end else begin
                    next_state = WALK_RIGHT;
                    walk_right = 1;
                end
            end
            
            FALLING: begin
                if (ground) begin
                    if (state == WALK_LEFT)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                    aaah = 1;
                end
            end
            
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else begin
                    next_state = DIGGING;
                    digging = 1;
                end
            end
        endcase
    end
    
endmodule