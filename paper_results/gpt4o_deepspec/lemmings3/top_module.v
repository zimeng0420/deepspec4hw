module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	input ground,
	input dig,
	output walk_left,
	output walk_right,
	output aaah,
	output digging
);

    // State enumeration
    typedef enum logic [2:0] {
        WALK_LEFT,
        WALK_RIGHT,
        FALLING,
        DIGGING
    } state_t;

    state_t current_state, next_state;

    // Sequential logic for state transitions
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT; // Reset to walk_left state
        end else begin
            current_state <= next_state; // Update state on clock edge
        end
    end

    // Combinational logic for next state
    always_comb begin
        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING; // Highest priority: Falling
                end else if (dig) begin
                    next_state = DIGGING; // Second priority: Digging
                end else if (bump_left) begin
                    next_state = WALK_RIGHT; // Switch direction when bumped left
                end else begin
                    next_state = WALK_LEFT; // Continue walking left
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING; // Highest priority: Falling
                end else if (dig) begin
                    next_state = DIGGING; // Second priority: Digging
                end else if (bump_right) begin
                    next_state = WALK_LEFT; // Switch direction when bumped right
                end else begin
                    next_state = WALK_RIGHT; // Continue walking right
                end
            end

            FALLING: begin
                if (ground) begin
                    next_state = (current_state == WALK_LEFT || current_state == DIGGING) ? WALK_LEFT : WALK_RIGHT; // Resume walking direction before fall
                end else begin
                    next_state = FALLING; // Continue falling
                end
            end

            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING; // Start falling when ground ends
                end else begin
                    next_state = DIGGING; // Continue digging
                end
            end

            default: begin
                next_state = WALK_LEFT; // Default state
            end
        endcase
    end

    // Output logic based on the current state (Moore FSM)
    assign walk_left = (current_state == WALK_LEFT);
    assign walk_right = (current_state == WALK_RIGHT);
    assign aaah = (current_state == FALLING);
    assign digging = (current_state == DIGGING);

endmodule