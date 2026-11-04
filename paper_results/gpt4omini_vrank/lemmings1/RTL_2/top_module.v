module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    typedef enum reg [1:0] {
        WALK_LEFT = 2'b00,
        WALK_RIGHT = 2'b01
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (bump_right) 
                    next_state = WALK_RIGHT;
                else 
                    next_state = WALK_LEFT;
            end
            
            WALK_RIGHT: begin
                if (bump_left) 
                    next_state = WALK_LEFT;
                else 
                    next_state = WALK_RIGHT;
            end
            
            default: next_state = WALK_LEFT; // default case
        endcase
    end

    // Output logic
    always @(*) begin
        walk_left = (current_state == WALK_LEFT);
        walk_right = (current_state == WALK_RIGHT);
    end

    // State update on clock
    always @(posedge clk or posedge areset) begin
        if (areset) 
            current_state <= WALK_LEFT;
        else 
            current_state <= next_state;
    end

endmodule