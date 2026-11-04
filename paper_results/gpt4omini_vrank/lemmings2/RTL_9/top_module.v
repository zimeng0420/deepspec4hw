module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    typedef enum reg [1:0] {
        LEFT,
        RIGHT,
        FALLING
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(current_state or bump_left or bump_right or ground) begin
        // Default outputs
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        next_state = current_state;

        case (current_state)
            LEFT: begin
                walk_left = 1;
                if (ground == 0) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (bump_right) begin
                    next_state = RIGHT;
                end
            end
            
            RIGHT: begin
                walk_right = 1;
                if (ground == 0) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (bump_left) begin
                    next_state = LEFT;
                end
            end
            
            FALLING: begin
                if (ground == 1) begin
                    if (current_state == LEFT) begin
                        next_state = LEFT;
                    end else if (current_state == RIGHT) begin
                        next_state = RIGHT;
                    end
                end
            end
        endcase
    end
endmodule