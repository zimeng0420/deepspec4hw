module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    typedef enum reg [1:0] {
        STATE_LEFT = 2'b00,
        STATE_RIGHT = 2'b01
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) 
            current_state <= STATE_LEFT; 
        else 
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            STATE_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                if (bump_right) 
                    next_state = STATE_RIGHT;
                else 
                    next_state = STATE_LEFT;
            end
            
            STATE_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                if (bump_left) 
                    next_state = STATE_LEFT;
                else 
                    next_state = STATE_RIGHT;
            end
            
            default: begin
                walk_left = 0;
                walk_right = 0;
                next_state = STATE_LEFT;
            end
        endcase
    end

endmodule