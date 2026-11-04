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

    // State Encoding
    typedef enum reg [2:0] {
        STATE_WALK_LEFT,
        STATE_WALK_RIGHT,
        STATE_FALL,
        STATE_DIG,
        STATE_SPLAT
    } state_t;

    state_t current_state, next_state;
    reg [4:0] fall_counter; // to count the falling cycles

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= STATE_WALK_LEFT;
            fall_counter <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == STATE_FALL) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0; // Reset fall counter when not in fall state
            end
        end
    end

    // Combinatorial logic for next state and outputs
    always @(*) begin
        // Default outputs
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        next_state = current_state;

        case (current_state)
            STATE_WALK_LEFT: begin
                if (!ground) begin
                    aaah = 1;
                    next_state = STATE_FALL;
                end else if (bump_right) begin
                    next_state = STATE_WALK_RIGHT;
                end else if (dig) begin
                    next_state = STATE_DIG;
                    digging = 1;
                end else begin
                    walk_left = 1;
                end
            end
            STATE_WALK_RIGHT: begin
                if (!ground) begin
                    aaah = 1;
                    next_state = STATE_FALL;
                end else if (bump_left) begin
                    next_state = STATE_WALK_LEFT;
                end else if (dig) begin
                    next_state = STATE_DIG;
                    digging = 1;
                end else begin
                    walk_right = 1;
                end
            end
            STATE_FALL: begin
                aaah = 1; // Always indicate falling
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = STATE_SPLAT;
                    end else begin
                        next_state = (walk_left) ? STATE_WALK_LEFT : STATE_WALK_RIGHT;
                    end
                end
            end
            STATE_DIG: begin
                if (!ground) begin
                    aaah = 1;
                    next_state = STATE_FALL;
                end else if (ground) begin
                    digging = 1; // Continue digging while on the ground
                    // Once in dig state, it will stay there until ground becomes 0
                end
            end
            STATE_SPLAT: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
                // Remain in splat state forever
            end
        endcase
    end

endmodule