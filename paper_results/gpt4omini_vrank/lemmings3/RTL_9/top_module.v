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

    typedef enum reg [1:0] {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING} state_t;
    state_t current_state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        next_state = current_state;
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                    walk_right = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                end else begin
                    walk_left = 1;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                    walk_left = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                end else begin
                    walk_right = 1;
                end
            end

            FALLING: begin
                if (ground) begin
                    if (current_state == FALLING) begin
                        if (walk_left) begin
                            next_state = WALK_LEFT;
                            walk_left = 1;
                        end else if (walk_right) begin
                            next_state = WALK_RIGHT;
                            walk_right = 1;
                        end
                    end
                end
            end

            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else begin
                    digging = 1;
                end
            end
            
        endcase
    end

endmodule