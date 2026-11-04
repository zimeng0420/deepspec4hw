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

    reg [4:0] state;
    reg [4:0] next_state;
    reg [4:0] FALL_LIMIT = 5'd20;
    reg [4:0] fall_counter;
    reg falling;

    typedef enum logic [2:0] {
        WALK_LEFT,
        WALK_RIGHT,
        FALL,
        DIG,
        SPLAT
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            fall_counter <= 0;
            falling <= 0;
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(current_state, ground, bump_left, bump_right, dig) begin
        next_state = current_state;
        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALL;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                end
                walk_left = 1;
                walk_right = 0;
            end
            
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                end
                walk_left = 0;
                walk_right = 1;
            end
            
            FALL: begin
                if (ground) begin
                    if (fall_counter > FALL_LIMIT) begin
                        next_state = SPLAT;
                        walk_left = 0;
                        walk_right = 0;
                        aaah = 0;
                        digging = 0;
                    end else begin
                        if (current_state == WALK_LEFT) begin
                            next_state = WALK_LEFT;
                        end else begin
                            next_state = WALK_RIGHT;
                        end
                    end
                end else begin
                    fall_counter = fall_counter + 1;
                    walk_left = 0;
                    walk_right = 0;
                    aaah = 1;
                end
            end
            
            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                    aaah = 1;
                end else begin
                    digging = 1;
                    if (bump_left || bump_right) begin
                        next_state = (current_state == WALK_LEFT) ? WALK_RIGHT : WALK_LEFT;
                    end
                end
                walk_left = 0;
                walk_right = 0;
            end
            
            SPLAT: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
            
            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end

endmodule