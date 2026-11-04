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

    typedef enum reg [2:0] {
        WALK_LEFT,
        WALK_RIGHT,
        FALLING,
        DIGGING,
        SPLATTER
    } state_t;

    state_t state, next_state;
    reg [4:0] fall_count; // Counter for falling cycles

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    always @(state or bump_left or bump_right or ground or dig or fall_count) begin
        case (state)
            WALK_LEFT: begin
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
                digging = 0;
                fall_count = 0;

                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                end else if (dig) begin
                    next_state = DIGGING;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            
            WALK_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
                digging = 0;
                fall_count = 0; 

                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (dig) begin
                    next_state = DIGGING;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALLING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;

                fall_count = fall_count + 1;

                if (ground) begin
                    if (fall_count > 20) begin
                        next_state = SPLATTER;
                    end else begin
                        next_state = (walk_left) ? WALK_LEFT : WALK_RIGHT;
                    end
                end else begin
                    next_state = FALLING;
                end
            end

            DIGGING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
                fall_count = 0;

                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    next_state = DIGGING;
                end else if (ground) begin
                    next_state = DIGGING;
                end else begin
                    next_state = DIGGING;
                end
            end

            SPLATTER: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end

            default: begin
                next_state = WALK_LEFT; // Default to initiative state
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end
endmodule