module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    typedef enum reg [1:0] {LEFT, RIGHT} state_t;
    state_t current_state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) 
            current_state <= LEFT;
        else 
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            LEFT: begin
                walk_left = 1;
                walk_right = 0;
                if (bump_left) 
                    next_state = RIGHT;
                else 
                    next_state = LEFT;
            end
            
            RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                if (bump_right) 
                    next_state = LEFT;
                else 
                    next_state = RIGHT;
            end
            
            default: begin
                walk_left = 0;
                walk_right = 0;
                next_state = LEFT;
            end
        endcase
    end

endmodule