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
        WALK_LEFT = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING = 2'b10
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        // Default outputs
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        next_state = current_state;

        case (current_state)
            WALK_LEFT: begin
                if (ground == 0) begin
                    aaah = 1;
                    next_state = FALLING;
                end else if (bump_right) begin
                    walk_right = 1;
                    next_state = WALK_RIGHT;
                end else begin
                    walk_left = 1;
                end
            end
            
            WALK_RIGHT: begin
                if (ground == 0) begin
                    aaah = 1;
                    next_state = FALLING;
                end else if (bump_left) begin
                    walk_left = 1;
                    next_state = WALK_LEFT;
                end else begin
                    walk_right = 1;
                end
            end
            
            FALLING: begin
                if (ground == 1) begin
                    if (current_state == WALK_LEFT) begin
                        walk_left = 1;
                    end else if (current_state == WALK_RIGHT) begin
                        walk_right = 1;
                    end
                    next_state = (current_state == WALK_LEFT) ? WALK_LEFT : WALK_RIGHT;
                end else begin
                    aaah = 1;
                end
            end
            
            default: next_state = WALK_LEFT; // Fallback to a default state
        endcase
    end
endmodule