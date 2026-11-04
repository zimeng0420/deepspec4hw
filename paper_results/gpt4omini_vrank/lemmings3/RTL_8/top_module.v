module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    typedef enum reg [1:0] {
        WALK_LEFT   = 2'b00,
        WALK_RIGHT  = 2'b01,
        FALLING     = 2'b10,
        DIGGING     = 2'b11
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
        digging = 0;

        case (current_state)
            WALK_LEFT: begin
                walk_left = 1;
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                walk_right = 1;
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALLING: begin
                aaah = 1;
                if (ground) begin
                    if (current_state == FALLING) begin
                        if (walk_left) begin
                            next_state = WALK_LEFT;
                        end else begin
                            next_state = WALK_RIGHT;
                        end
                    end
                end else begin
                    next_state = FALLING;
                end
            end

            DIGGING: begin
                digging = 1;
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (ground && !dig) begin
                    if (walk_left) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    next_state = DIGGING;
                end
            end
        
            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end

endmodule