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
        WALK_LEFT = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING = 2'b10,
        DIGGING = 2'b11
    } state_t;
    
    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (!ground) 
                    next_state = FALLING;
                else if (dig) 
                    next_state = DIGGING;
                else if (bump_right) 
                    next_state = WALK_RIGHT;
                else 
                    next_state = WALK_LEFT;
            end

            WALK_RIGHT: begin
                if (!ground) 
                    next_state = FALLING;
                else if (dig) 
                    next_state = DIGGING;
                else if (bump_left) 
                    next_state = WALK_LEFT;
                else 
                    next_state = WALK_RIGHT;
            end

            FALLING: begin
                if (ground) 
                    next_state = (walk_left) ? WALK_LEFT : WALK_RIGHT;
                else 
                    next_state = FALLING;
            end

            DIGGING: begin
                if (!ground) 
                    next_state = FALLING;
                else 
                    next_state = DIGGING;
            end

            default: next_state = WALK_LEFT; // reset state
        endcase
    end

    // State output logic
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (current_state)
            WALK_LEFT: begin
                walk_left = 1;
            end

            WALK_RIGHT: begin
                walk_right = 1;
            end

            FALLING: begin
                aaah = 1;
            end

            DIGGING: begin
                digging = 1;
            end
        endcase
    end

    // Sequential logic for state transition
    always @(posedge clk or posedge areset) begin
        if (areset) 
            current_state <= WALK_LEFT;
        else 
            current_state <= next_state;
    end

endmodule