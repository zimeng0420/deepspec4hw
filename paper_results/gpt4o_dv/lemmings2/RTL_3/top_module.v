module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State encoding
    typedef enum logic [1:0] {
        WALK_LEFT = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING = 2'b10
    } state_t;

    // State registers
    state_t current_state, next_state;

    // State transition and output logic
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (!ground) 
                    next_state = FALLING;
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end

            WALK_RIGHT: begin
                if (!ground) 
                    next_state = FALLING;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end

            FALLING: begin
                if (ground) begin
                    if (bump_left || bump_right) 
                        next_state = current_state == WALK_LEFT ? WALK_RIGHT : WALK_LEFT;
                    else 
                        next_state = current_state == WALK_LEFT ? WALK_LEFT : WALK_RIGHT;
                end
                else
                    next_state = FALLING;
            end

            default: 
                next_state = WALK_LEFT;
        endcase
    end

    // Sequential logic for state transitions
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= WALK_LEFT;
        else
            current_state <= next_state;
    end

    // Output logic based on current state
    assign walk_left = (current_state == WALK_LEFT);
    assign walk_right = (current_state == WALK_RIGHT);
    assign aaah = (current_state == FALLING);

endmodule