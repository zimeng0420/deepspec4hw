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
    reg [4:0] fall_count; // 5 bits to count up to 20

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 0;
        end else begin
            state <= next_state;
            if (state == FALLING) 
                fall_count <= fall_count + 1;
            else 
                fall_count <= 0;
        end
    end

    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                    digging = 0;
                    walk_left = 0;
                    walk_right = 0;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                    aaah = 0;
                    walk_left = 0;
                    walk_right = 0;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                    digging = 0;
                    aaah = 0;
                    walk_left = 0;
                    walk_right = 1;
                end else begin
                    next_state = WALK_LEFT;
                    digging = 0;
                    aaah = 0;
                    walk_left = 1;
                    walk_right = 0;
                end
            end
            
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                    digging = 0;
                    walk_left = 0;
                    walk_right = 0;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                    aaah = 0;
                    walk_left = 0;
                    walk_right = 0;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                    digging = 0;
                    aaah = 0;
                    walk_left = 1;
                    walk_right = 0;
                end else begin
                    next_state = WALK_RIGHT;
                    digging = 0;
                    aaah = 0;
                    walk_left = 0;
                    walk_right = 1;
                end
            end
            
            FALLING: begin
                if (ground) begin
                    if (fall_count > 20) begin
                        next_state = SPLATTER;
                    end else begin
                        if (walk_left) begin
                            next_state = WALK_LEFT;
                        end else begin
                            next_state = WALK_RIGHT;
                        end
                    end
                    digging = 0;
                    aaah = 0;
                    walk_left = 0;
                    walk_right = 0;
                end else begin
                    next_state = FALLING;
                    digging = 0;
                    aaah = 1;
                    walk_left = 0;
                    walk_right = 0;
                end
            end
            
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                    digging = 0;
                    aaah = 1;
                    walk_left = 0;
                    walk_right = 0;
                end else begin
                    next_state = DIGGING;
                    digging = 1;
                    aaah = 0;
                    walk_left = 0;
                    walk_right = 0;
                end
            end
            
            SPLATTER: begin
                next_state = SPLATTER;
                digging = 0;
                aaah = 0;
                walk_left = 0;
                walk_right = 0;
            end
            
            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end

endmodule