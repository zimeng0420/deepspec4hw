module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);
    // State encoding
    reg current_state, next_state;
    localparam LEFT = 1'b0, RIGHT = 1'b1;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) 
            current_state <= LEFT;
        else 
            current_state <= next_state;
    end
    
    // Next state logic
    always @(*) begin
        case (current_state)
            LEFT: begin
                if (bump_left) 
                    next_state = RIGHT;
                else 
                    next_state = LEFT;
            end
            RIGHT: begin
                if (bump_right) 
                    next_state = LEFT;
                else 
                    next_state = RIGHT;
            end
        endcase
    end

    // Output logic
    assign walk_left = (current_state == LEFT);
    assign walk_right = (current_state == RIGHT);
endmodule