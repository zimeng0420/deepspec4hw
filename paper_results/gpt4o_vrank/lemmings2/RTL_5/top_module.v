module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // State Encoding
    typedef enum logic [1:0] {
        LEFT  = 2'b00,
        RIGHT = 2'b01,
        FALL  = 2'b10
    } state_t;

    state_t current_state, next_state;
    state_t walking_state;  // To keep the walking direction before falling

    // Sequential logic for state transition
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= LEFT;  // Start walking left on reset
            walking_state <= LEFT;
        end else begin
            current_state <= next_state;
            if (ground)
                walking_state <= next_state;  // Update walking direction only if on ground
        end
    end

    // Combinational logic for next state
    always_comb begin
        case (current_state)
            LEFT: begin
                if (!ground)
                    next_state = FALL;
                else if (bump_left)
                    next_state = RIGHT;
                else
                    next_state = LEFT;
            end
            RIGHT: begin
                if (!ground)
                    next_state = FALL;
                else if (bump_right)
                    next_state = LEFT;
                else
                    next_state = RIGHT;
            end
            FALL: begin
                if (ground)
                    next_state = walking_state;  // Resume previous walking state
                else
                    next_state = FALL;
            end
            default: next_state = LEFT;  // Default to a known state
        endcase
    end

    // Output logic
    assign walk_left = (current_state == LEFT);
    assign walk_right = (current_state == RIGHT);
    assign aaah = (current_state == FALL);

endmodule