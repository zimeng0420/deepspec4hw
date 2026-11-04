module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    typedef enum logic [1:0] {
        LEFT = 2'b00,
        RIGHT = 2'b01
    } state_t;

    state_t state, next_state;

    // State transition process
    always_ff @(posedge clk or posedge areset) begin
        if (areset) 
            state <= LEFT; 
        else 
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        case (state)
            LEFT: begin
                walk_left = 1;
                walk_right = 0;
                if (bump_right) 
                    next_state = RIGHT;
                else 
                    next_state = LEFT;
            end
            RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                if (bump_left) 
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