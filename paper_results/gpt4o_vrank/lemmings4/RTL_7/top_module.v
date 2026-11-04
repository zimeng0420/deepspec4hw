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
    typedef enum logic [2:0] {
        LEFT = 3'b000,
        RIGHT = 3'b001,
        FALL_LEFT = 3'b010,
        FALL_RIGHT = 3'b011,
        DIG_LEFT = 3'b100,
        DIG_RIGHT = 3'b101,
        SPLATTER = 3'b110
    } state_type;
    
    state_type current_state, next_state;
    integer fall_counter;

    // State transition logic
    always @(*) begin
        next_state = current_state; // Default to remain in current state
        case (current_state)
            LEFT: begin
                if (!ground) next_state = FALL_LEFT;
                else if (dig) next_state = DIG_LEFT;
                else if (bump_left) next_state = RIGHT;
            end
            RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
                else if (dig) next_state = DIG_RIGHT;
                else if (bump_right) next_state = LEFT;
            end
            FALL_LEFT: begin
                if (ground) next_state = (fall_counter > 20) ? SPLATTER : LEFT;
            end
            FALL_RIGHT: begin
                if (ground) next_state = (fall_counter > 20) ? SPLATTER : RIGHT;
            end
            DIG_LEFT: begin
                if (!ground) next_state = FALL_LEFT;
            end
            DIG_RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
            end
            SPLATTER: begin
                // Remain in SPLATTER
            end
        endcase
    end

    // Synchronous state and counter updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= LEFT;
            fall_counter <= 0;
        end
        else begin
            current_state <= next_state;
            if (current_state == FALL_LEFT || current_state == FALL_RIGHT) begin
                fall_counter <= fall_counter + 1;
            end 
            else begin
                fall_counter <= 0;
            end
        end
    end

    // Output logic based on current state
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (current_state)
            LEFT: walk_left = 1;
            RIGHT: walk_right = 1;
            FALL_LEFT, FALL_RIGHT: aaah = 1;
            DIG_LEFT: begin
                walk_left = 1;
                digging = 1;
            end
            DIG_RIGHT: begin
                walk_right = 1;
                digging = 1;
            end
            SPLATTER: begin
                // All outputs remain 0
            end
        endcase
    end

endmodule