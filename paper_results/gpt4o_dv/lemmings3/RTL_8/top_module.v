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

    // Defining state encoding
    typedef enum logic [1:0] {
        WALK_LEFT,
        WALK_RIGHT,
        FALLING,
        DIGGING
    } state_t;

    state_t state, next_state;  // Current and next state

    // State transition logic (sequential)
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic (combinational)
    always_comb begin
        // Default: hold state
        next_state = state;
        
        // Priority: Falling, Digging, Direction
        case (state)
            WALK_LEFT: begin
                if (~ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (~ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end
            end
            FALLING: begin
                if (ground) begin
                    next_state = (state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
                end
            end
            DIGGING: begin
                if (~ground) begin
                    next_state = FALLING;
                end
            end
        endcase
    end

    // Output logic (Moore machine outputs are only state dependent)
    always_comb begin
        // Default: all outputs low
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        
        case (state)
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

endmodule