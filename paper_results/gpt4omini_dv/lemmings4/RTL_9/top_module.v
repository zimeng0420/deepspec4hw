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

    typedef enum reg [1:0] {WALK_LEFT, WALK_RIGHT, FALL, DIG} state_t;
    state_t current_state, next_state;
    
    reg [4:0] fall_counter; // Count the number of clock cycles falling

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            fall_counter <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == FALL) begin
                fall_counter <= fall_counter + 1;
            end else if (ground) begin
                fall_counter <= 0;
            end
        end
    end

    always @* begin
        // Default outputs
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (current_state)
            WALK_LEFT: begin
                if (bump_right) begin
                    next_state = WALK_RIGHT;
                end else if (ground == 0) begin
                    next_state = FALL;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIG;
                    digging = 1;
                end else begin
                    walk_left = 1;
                    next_state = WALK_LEFT;
                end
            end
            
            WALK_RIGHT: begin
                if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (ground == 0) begin
                    next_state = FALL;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIG;
                    digging = 1;
                end else begin
                    walk_right = 1;
                    next_state = WALK_RIGHT;
                end
            end
            
            FALL: begin
                aaah = 1;
                if (ground) begin
                    if (fall_counter <= 20) begin
                        if (bump_right) begin
                            next_state = WALK_LEFT;
                        end else if (bump_left) begin
                            next_state = WALK_RIGHT;
                        end else begin
                            if (walk_right) begin
                                next_state = WALK_RIGHT;
                            end else begin
                                next_state = WALK_LEFT;
                            end
                        end
                    end else begin
                        walk_left = 0;
                        walk_right = 0;
                        digging = 0;
                        aaah = 0;
                    end
                end else begin
                    next_state = FALL;
                end
            end
            
            DIG: begin
                if (ground == 0) begin
                    next_state = FALL;
                    aaah = 1;
                end else begin
                    digging = 1;
                    if (bump_left) begin
                        next_state = WALK_RIGHT;
                    end else if (bump_right) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = DIG;
                    end
                end
            end
            
            default: next_state = WALK_LEFT; // Default to walk left on reset
        endcase
    end
endmodule