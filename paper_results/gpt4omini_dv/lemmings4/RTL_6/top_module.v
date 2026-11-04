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

    typedef enum logic [1:0] {
        WALK_LEFT,
        WALK_RIGHT,
        FALLING,
        DIGGING,
        SPLATTER
    } state_t;

    state_t current_state, next_state;
    reg [4:0] fall_counter; // Counts the number of clock cycles falling

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            fall_counter <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == FALLING) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0; // Reset counter if not falling
            end
        end
    end
  
    always_comb begin
        // Default state outputs
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        
        case (current_state)
            WALK_LEFT: begin
                walk_left = 1;
                if (bump_right) next_state = WALK_RIGHT; // Change direction
                else if (ground == 0) next_state = FALLING; // Detect fall
                else if (dig) next_state = DIGGING; // Start digging
                else next_state = WALK_LEFT; // Remain walking left
            end

            WALK_RIGHT: begin
                walk_right = 1;
                if (bump_left) next_state = WALK_LEFT; // Change direction
                else if (ground == 0) next_state = FALLING; // Detect fall
                else if (dig) next_state = DIGGING; // Start digging
                else next_state = WALK_RIGHT; // Remain walking right
            end

            FALLING: begin
                aaah = 1; // Set falling output
                if (ground) begin
                    if (fall_counter > 20) next_state = SPLATTER; // Check splatter condition
                    else next_state = current_state; // Remain in falling
                end else begin
                    next_state = FALLING; // Continue falling
                end
            end

            DIGGING: begin
                digging = 1; // Set digging output
                if (ground == 0) begin
                    next_state = FALLING; // Fall if ground is gone
                end else if (bump_left || bump_right) begin
                    next_state = DIGGING; // Stay digging while bumped
                end else if (ground) begin
                    next_state = current_state; // Continue digging
                end
            end

            SPLATTER: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0; // Cease all actions
                // Stay in the splat condition until reset
                next_state = SPLATTER;
            end
        endcase
    end

endmodule