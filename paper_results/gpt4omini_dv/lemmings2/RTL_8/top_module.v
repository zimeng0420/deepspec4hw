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

    typedef enum logic [1:0] {
        LEFT, 
        RIGHT, 
        FALLING
    } state_t;
    
    state_t state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) 
            state <= LEFT;  // Start walking left on reset
        else 
            state <= next_state;
    end

    always_comb begin
        // Default outputs
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        
        case (state)
            LEFT: begin
                walk_left = 1;
                if (!ground) begin
                    aaah = 1;
                    next_state = FALLING;
                end else if (bump_right) begin
                    next_state = RIGHT;
                end else if (bump_left) begin
                    next_state = LEFT;
                end else begin
                    next_state = LEFT;
                end
            end
            
            RIGHT: begin
                walk_right = 1;
                if (!ground) begin
                    aaah = 1;
                    next_state = FALLING;
                end else if (bump_left) begin
                    next_state = LEFT;
                end else if (bump_right) begin
                    next_state = RIGHT;
                end else begin
                    next_state = RIGHT;
                end
            end
            
            FALLING: begin
                aaah = 1;
                if (ground) begin
                    if (walk_left) 
                        next_state = LEFT;
                    else 
                        next_state = RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end
            
            default: next_state = LEFT; // Safe default
        endcase
    end
endmodule