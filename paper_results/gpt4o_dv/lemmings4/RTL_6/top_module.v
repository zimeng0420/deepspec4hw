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

    // State definitions
    typedef enum reg [2:0] {
        WALK_LEFT    = 3'b000,
        WALK_RIGHT   = 3'b001,
        FALL_LEFT    = 3'b010,
        FALL_RIGHT   = 3'b011,
        DIG_LEFT     = 3'b100,
        DIG_RIGHT    = 3'b101,
        SPLATTERED   = 3'b110
    } state_t;

    reg [2:0] state, next_state;
    reg [4:0] fall_count; // Counter for falling duration

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 0;
        end else begin
            state <= next_state;
            
            if (state == FALL_LEFT || state == FALL_RIGHT) begin
                fall_count <= fall_count + 1;
            end else begin
                fall_count <= 0;
            end
        end
    end

    always @(*) begin
        case (state)
            WALK_LEFT: begin
                walk_left = ground && ~dig;
                walk_right = 0;
                aaah = ~ground;
                digging = ground && dig;
                if (!ground) begin
                    next_state = FALL_LEFT;
                end else if (dig) begin
                    next_state = DIG_LEFT;
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                walk_left = 0;
                walk_right = ground && ~dig;
                aaah = ~ground;
                digging = ground && dig;
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else if (dig) begin
                    next_state = DIG_RIGHT;
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            FALL_LEFT: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
                if (ground) begin
                    if (fall_count >= 20) begin
                        next_state = SPLATTERED;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end else begin
                    next_state = FALL_LEFT;
                end
            end

            FALL_RIGHT: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
                if (ground) begin
                    if (fall_count >= 20) begin
                        next_state = SPLATTERED;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    next_state = FALL_RIGHT;
                end
            end

            DIG_LEFT: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
                if (!ground) begin
                    next_state = FALL_LEFT;
                end else begin
                    next_state = DIG_LEFT;
                end
            end

            DIG_RIGHT: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else begin
                    next_state = DIG_RIGHT;
                end
            end

            SPLATTERED: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
                next_state = SPLATTERED;
            end

            default: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
                next_state = WALK_LEFT; // Default to initial state
            end
        endcase
    end
endmodule