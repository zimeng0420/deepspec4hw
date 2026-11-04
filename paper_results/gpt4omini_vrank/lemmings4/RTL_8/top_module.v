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
        FALL,
        DIGGING,
        SPLAT
    } state_t;

    state_t current_state, next_state;
    reg [4:0] fall_counter; // 5 bits for counting up to 20

    // Asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            fall_counter <= 0;
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        // Default outputs
        next_state = current_state;
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (current_state)
            WALK_LEFT: begin
                walk_left = 1;
                if (~ground) begin
                    aaah = 1;
                    next_state = FALL;
                end else if (dig) begin
                    digging = 1;
                    next_state = DIGGING;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                end
            end

            WALK_RIGHT: begin
                walk_right = 1;
                if (~ground) begin
                    aaah = 1;
                    next_state = FALL;
                end else if (dig) begin
                    digging = 1;
                    next_state = DIGGING;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                end
            end

            FALL: begin
                aaah = 1;
                fall_counter = fall_counter + 1;
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = SPLAT;
                    end else begin
                        next_state = (bump_left && ~bump_right) ? WALK_RIGHT :
                                     (bump_right && ~bump_left) ? WALK_LEFT :
                                     (walk_left ? WALK_LEFT : WALK_RIGHT);
                        fall_counter = 0;
                    end
                end
            end

            DIGGING: begin
                digging = 1;
                if (~ground) begin
                    aaah = 1;
                    next_state = FALL;
                end else if (ground) begin
                    next_state = (bump_left && ~bump_right) ? WALK_RIGHT :
                                 (bump_right && ~bump_left) ? WALK_LEFT :
                                 (walk_left ? WALK_LEFT : WALK_RIGHT);
                end
            end

            SPLAT: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end

        endcase
    end

endmodule