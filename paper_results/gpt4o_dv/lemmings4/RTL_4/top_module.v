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
        S_WALK_LEFT,
        S_WALK_RIGHT,
        S_FALL_LEFT,
        S_FALL_RIGHT,
        S_DIG_LEFT,
        S_DIG_RIGHT,
        S_SPLATTER
    } state_t;

    state_t state, next_state;
    reg [4:0] fall_counter; // 5-bit counter to count up to 20 clock cycles

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S_WALK_LEFT;
        else
            state <= next_state;
    end

    always @(state or bump_left or bump_right or ground or dig or fall_counter) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        next_state = state; // Default to staying in the same state
        case (state)
            S_WALK_LEFT: begin
                if (!ground)
                    next_state = S_FALL_LEFT;
                else if (dig)
                    next_state = S_DIG_LEFT;
                else if (bump_left)
                    next_state = S_WALK_RIGHT;
                walk_left = 1;
            end
            S_WALK_RIGHT: begin
                if (!ground)
                    next_state = S_FALL_RIGHT;
                else if (dig)
                    next_state = S_DIG_RIGHT;
                else if (bump_right)
                    next_state = S_WALK_LEFT;
                walk_right = 1;
            end
            S_FALL_LEFT, S_FALL_RIGHT: begin
                if (ground) begin
                    if (fall_counter > 5'd20)
                        next_state = S_SPLATTER;
                    else
                        next_state = (state == S_FALL_LEFT) ? S_WALK_LEFT : S_WALK_RIGHT;
                end
                aaah = 1;
            end
            S_DIG_LEFT: begin
                if (!ground)
                    next_state = S_FALL_LEFT;
                else
                    digging = 1;
            end
            S_DIG_RIGHT: begin
                if (!ground)
                    next_state = S_FALL_RIGHT;
                else
                    digging = 1;
            end
            S_SPLATTER: begin
                // All outputs remain 0;
            end
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            fall_counter <= 0;
        else if (state == S_FALL_LEFT || state == S_FALL_RIGHT)
            fall_counter <= fall_counter + 1;
        else
            fall_counter <= 0;
    end

endmodule