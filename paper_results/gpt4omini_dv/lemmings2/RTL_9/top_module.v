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

    typedef enum logic [1:0] {
        WALK_LEFT = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING = 2'b10
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(current_state or bump_left or bump_right or ground) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;

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
                    next_state = WALK_LEFT;
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
                    next_state = WALK_RIGHT;
                end
            end

            FALLING: begin
                if (ground == 1) begin
                    if (walk_left) begin
                        walk_left = 1;
                        next_state = WALK_LEFT;
                    end else if (walk_right) begin
                        walk_right = 1;
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    aaah = 1;
                    next_state = FALLING;
                end
            end

            default: next_state = WALK_LEFT; // Safe default
        endcase
    end

endmodule