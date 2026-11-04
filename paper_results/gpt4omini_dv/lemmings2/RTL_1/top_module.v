module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    typedef enum logic [1:0] {
        WALK_LEFT = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING = 2'b10
    } state_t;
    
    state_t state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    always @* begin
        aaah = 0;
        walk_left = 0;
        walk_right = 0;
        
        case (state)
            WALK_LEFT: begin
                if (ground) begin
                    walk_left = 1;
                    if (bump_right) begin
                        next_state = WALK_RIGHT;
                    end else if (bump_left) begin
                        next_state = WALK_RIGHT;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end else begin
                    aaah = 1;
                    next_state = FALLING;
                end
            end
            WALK_RIGHT: begin
                if (ground) begin
                    walk_right = 1;
                    if (bump_left) begin
                        next_state = WALK_LEFT;
                    end else if (bump_right) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    aaah = 1;
                    next_state = FALLING;
                end
            end
            FALLING: begin
                aaah = 1;
                if (ground) begin
                    if (walk_left) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    next_state = FALLING;
                end
            end
            default: next_state = WALK_LEFT;
        endcase
    end

endmodule