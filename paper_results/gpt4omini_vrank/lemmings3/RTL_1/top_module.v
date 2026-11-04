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
        WALK_LEFT = 2'b00,
        WALK_RIGHT = 2'b01,
        FALL = 2'b10,
        DIGGING = 2'b11
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    always @* begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        next_state = current_state;

        case(current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    aaah = 1;
                    next_state = FALL;
                end else if (dig) begin
                    digging = 1;
                    next_state = DIGGING;
                end else if (bump_right) begin
                    walk_right = 1;
                    next_state = WALK_RIGHT;
                end else begin
                    walk_left = 1;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    aaah = 1;
                    next_state = FALL;
                end else if (dig) begin
                    digging = 1;
                    next_state = DIGGING;
                end else if (bump_left) begin
                    walk_left = 1;
                    next_state = WALK_LEFT;
                end else begin
                    walk_right = 1;
                end
            end
            FALL: begin
                if (ground) begin
                    if (current_state == FALL && !bump_left && !bump_right) begin
                        if (walk_left) begin
                            walk_left = 1;
                        end else if (walk_right) begin
                            walk_right = 1;
                        end
                    end
                    next_state = (walk_left) ? WALK_LEFT : WALK_RIGHT;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    aaah = 1;
                    next_state = FALL;
                end else begin
                    digging = 1;
                end
            end
        endcase
    end

endmodule