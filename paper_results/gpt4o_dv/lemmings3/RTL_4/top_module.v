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

    typedef enum logic [1:0] {
        WALK_LEFT = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING = 2'b10,
        DIGGING = 2'b11
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= WALK_LEFT; // Start by walking left on reset
        else
            current_state <= next_state;
    end

    always @(*) begin
        // Default assignments
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        
        case (current_state)
            WALK_LEFT: begin
                if (~ground) begin
                    aaah = 1;                               // Fall if no ground
                    next_state = FALLING;
                end
                else if (dig) begin
                    digging = 1;                           // Dig if commanded and on ground
                    next_state = DIGGING;
                end
                else if (bump_left) begin
                    walk_right = 1;                        // Switch direction to right if bumped on left
                    next_state = WALK_RIGHT;
                end
                else begin
                    walk_left = 1;                         // Continue walking left
                    next_state = WALK_LEFT;
                end
            end
            
            WALK_RIGHT: begin
                if (~ground) begin
                    aaah = 1;                               // Fall if no ground
                    next_state = FALLING;
                end 
                else if (dig) begin
                    digging = 1;                           // Dig if commanded and on ground
                    next_state = DIGGING;
                end 
                else if (bump_right) begin
                    walk_left = 1;                         // Switch direction to left if bumped on right
                    next_state = WALK_LEFT;
                end 
                else begin
                    walk_right = 1;                        // Continue walking right
                    next_state = WALK_RIGHT;
                end
            end
            
            FALLING: begin
                aaah = 1;                                   // Continue falling until ground reappears
                if (ground) begin
                    if (walk_left)
                        next_state = WALK_LEFT;            // Resume walking left
                    else if (walk_right)
                        next_state = WALK_RIGHT;           // Resume walking right
                end 
                else begin
                    next_state = FALLING;
                end
            end
            
            DIGGING: begin
                digging = 1;                                // Continue digging until there is no ground
                if (~ground) begin
                    aaah = 1;                               // Fall once digging ends if no ground
                    next_state = FALLING;
                end 
                else begin
                    next_state = DIGGING;
                end
            end
        endcase
    end

endmodule