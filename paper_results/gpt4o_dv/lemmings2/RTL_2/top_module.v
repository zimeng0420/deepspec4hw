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

    // State declaration
    typedef enum reg [1:0] {
        STATE_WALK_LEFT = 2'b00,
        STATE_WALK_RIGHT = 2'b01,
        STATE_FALLING = 2'b10
    } state_t;
    
    // State registers
    reg [1:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        if (!ground) begin
            next_state = STATE_FALLING;  // Transition to falling state if no ground
        end else begin
            case (current_state)
                STATE_WALK_LEFT: begin
                    if (bump_left)
                        next_state = STATE_WALK_RIGHT;
                    else
                        next_state = STATE_WALK_LEFT;
                end
                
                STATE_WALK_RIGHT: begin
                    if (bump_right)
                        next_state = STATE_WALK_LEFT;
                    else
                        next_state = STATE_WALK_RIGHT;
                end
                
                STATE_FALLING: begin
                    if (ground)
                        next_state = current_state; // Return to previous walking state
                end
                
                default: next_state = STATE_WALK_LEFT;  // Default to a known state
            endcase
        end
    end

    // Sequential logic for state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_WALK_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic based on current state
    assign aaah = (current_state == STATE_FALLING);
    assign walk_left = (current_state == STATE_WALK_LEFT);
    assign walk_right = (current_state == STATE_WALK_RIGHT);

endmodule