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

    typedef enum logic [2:0] {
        WALK_LEFT,
        WALK_RIGHT,
        FALLING,
        DIGGING,
        SPLATTER
    } state_t;

    state_t current_state, next_state;
    logic [4:0] fall_counter; // to count falling clock cycles

    // Asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            fall_counter <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == FALLING) begin
                if (fall_counter < 20) 
                    fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0; // reset fall counter
            end
        end
    end

    // Next state logic
    always_comb begin
        next_state = current_state;
        aaah = 0;
        walk_left = 0;
        walk_right = 0;
        digging = 0;

        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                end else begin
                    walk_left = 1;
                end
            end
            
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    next_state = DIGGING;
                    digging = 1;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                end else begin
                    walk_right = 1;
                end
            end
            
            FALLING: begin
                aaah = 1;
                if (ground) begin
                    if (fall_counter >= 20) begin
                        next_state = SPLATTER;
                    end else begin
                        // Resume last direction
                        next_state = (walk_left ? WALK_LEFT : WALK_RIGHT);
                    end
                end
            end
            
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else begin
                    digging = 1; // continue digging
                end
            end
            
            SPLATTER: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end

endmodule