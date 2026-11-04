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

    // State encoding
    typedef enum logic [2:0] {
        LEFT_WALK  = 3'b000,
        RIGHT_WALK = 3'b001,
        FALL_LEFT  = 3'b010,
        FALL_RIGHT = 3'b011,
        DIG_LEFT   = 3'b100,
        DIG_RIGHT  = 3'b101,
        SPLATTER   = 3'b110
    } state_t;

    state_t state, next_state;
    logic [5:0] fall_counter;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT_WALK;
        else
            state <= next_state;
    end

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            fall_counter <= 6'd0;
        else if (aaah)
            fall_counter <= fall_counter + 1'b1;
        else 
            fall_counter <= 6'd0;
    end

    always_comb begin
        // Default outputs
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (state)
            LEFT_WALK: begin
                if (!ground) 
                    next_state = FALL_LEFT;
                else if (dig) 
                    next_state = DIG_LEFT;
                else if (bump_left)
                    next_state = RIGHT_WALK;
                else
                    next_state = LEFT_WALK;

                walk_left = 1;
            end
            
            RIGHT_WALK: begin
                if (!ground) 
                    next_state = FALL_RIGHT;
                else if (dig) 
                    next_state = DIG_RIGHT;
                else if (bump_right)
                    next_state = LEFT_WALK;
                else
                    next_state = RIGHT_WALK;

                walk_right = 1;
            end
            
            FALL_LEFT, FALL_RIGHT: begin
                aaah = 1;

                if (fall_counter > 20)
                    next_state = SPLATTER;
                else if (ground) 
                    next_state = state == FALL_LEFT ? LEFT_WALK : RIGHT_WALK;
                else
                    next_state = state;
            end

            DIG_LEFT: begin
                digging = 1;
                if (!ground)
                    next_state = FALL_LEFT;
                else
                    next_state = DIG_LEFT;
            end
            
            DIG_RIGHT: begin
                digging = 1;
                if (!ground)
                    next_state = FALL_RIGHT;
                else
                    next_state = DIG_RIGHT;
            end

            SPLATTER: begin
                next_state = SPLATTER; // Remain in splatter state
            end
        endcase
    end

endmodule