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
        DIGGING
    } state_t;

    state_t current_state, next_state;

    // State transition
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @* begin
        case (current_state)
            WALK_LEFT: begin
                aaah = 0;
                digging = 0;
                walk_left = 1;
                walk_right = 0;
                if (!ground) begin
                    next_state = FALL;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                end else if (dig) begin
                    next_state = DIGGING;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            
            WALK_RIGHT: begin
                aaah = 0;
                digging = 0;
                walk_left = 0;
                walk_right = 1;
                if (!ground) begin
                    next_state = FALL;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (dig) begin
                    next_state = DIGGING;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            
            FALL: begin
                aaah = 1;
                digging = 0;
                walk_left = 0;
                walk_right = 0;
                if (ground) begin
                    if (current_state == WALK_LEFT) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    next_state = FALL;
                end
            end
            
            DIGGING: begin
                aaah = 0;
                digging = 1;
                walk_left = 0;
                walk_right = 0;
                if (!ground) begin
                    next_state = FALL;
                end else if (ground) begin
                    next_state = WALK_LEFT;  // or WALK_RIGHT depending on the initial direction
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