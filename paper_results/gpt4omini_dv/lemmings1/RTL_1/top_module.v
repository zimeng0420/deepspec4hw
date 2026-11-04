module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // State encoding
    typedef enum logic [1:0] {
        WALK_LEFT = 2'b00,
        WALK_RIGHT = 2'b01
    } state_t;

    state_t current_state, next_state;

    // Asynchronous reset to walk left
    always @(posedge areset) begin
        current_state <= WALK_LEFT;
    end

    // State transition logic
    always @(posedge clk) begin
        current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (bump_left)
                    next_state = WALK_RIGHT;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_LEFT;
            end
            
            WALK_RIGHT: begin
                if (bump_right)
                    next_state = WALK_LEFT;
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_RIGHT;
            end
            
            default: next_state = WALK_LEFT; // Default state
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                walk_left = 1;
                walk_right = 0;
            end
            
            WALK_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
            end
            
            default: begin
                walk_left = 0;
                walk_right = 0; // Default output
            end
        endcase
    end

endmodule