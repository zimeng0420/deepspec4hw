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
    typedef enum reg [2:0] {
        WALK_LEFT   = 3'b000,
        WALK_RIGHT  = 3'b001,
        FALLING     = 3'b010,
        DIGGING     = 3'b011,
        SPLATTER    = 3'b100
    } state_t;
    
    state_t current_state, next_state;
    reg [4:0] fall_counter;  // 5 bits for counting up to 20

    // Sequential Block
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;  
            fall_counter <= 0;
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == FALLING) begin
                if (fall_counter < 20)
                    fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0; // Reset counter when not falling
            end
        end
    end

    // Combinational Block
    always @(*) begin
        // Default outputs
        {walk_left, walk_right, aaah, digging} = 4'b0000;
        next_state = current_state;

        case (current_state)
            WALK_LEFT: begin
                walk_left = 1;
                if (bump_right) begin
                    next_state = WALK_RIGHT;
                end else if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                end
            end
            
            WALK_RIGHT: begin
                walk_right = 1;
                if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                end
            end
            
            FALLING: begin
                aaah = 1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = SPLATTER;
                    end else begin
                        // Update direction without changing it, since falling has priority
                        if (walk_left)
                            next_state = WALK_LEFT;
                        else
                            next_state = WALK_RIGHT;
                    end
                end
            end
            
            DIGGING: begin
                digging = 1;
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (bump_left || bump_right) begin
                    // Ignore bumps while digging
                    next_state = DIGGING;
                end
            end
            
            SPLATTER: begin
                // No walking, falling, or digging; all outputs are inactive.
            end
            
            default: next_state = WALK_LEFT; // Default to walking left on any unknown state
        endcase
    end
endmodule