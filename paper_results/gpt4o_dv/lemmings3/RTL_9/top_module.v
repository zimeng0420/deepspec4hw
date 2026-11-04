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
    typedef enum reg [1:0] {
        WALK_LEFT = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING = 2'b10,
        DIGGING = 2'b11
    } state_t;

    state_t state, next_state;

    // State transition logic (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic (combinatorial)
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING; // Fall
                end else if (dig) begin
                    next_state = DIGGING; // Dig
                end else if (bump_left) begin
                    next_state = WALK_RIGHT; // Switch direction
                end else begin
                    next_state = WALK_LEFT; // Continue walking left
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING; // Fall
                end else if (dig) begin
                    next_state = DIGGING; // Dig
                end else if (bump_right) begin
                    next_state = WALK_LEFT; // Switch direction
                end else begin
                    next_state = WALK_RIGHT; // Continue walking right
                end
            end

            FALLING: begin
                if (ground) begin
                    // Return to the previous direction
                    // We use the previous state to determine direction
                    if (state == WALK_LEFT) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_RIGHT;
                    end
                end else begin
                    next_state = FALLING; // Continue falling
                end
            end

            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING; // Start falling after digging
                end else begin
                    next_state = DIGGING; // Continue digging
                end
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic (combinatorial)
    always @(*) begin
        // Default all outputs to zero
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (state)
            WALK_LEFT: walk_left = 1;
            WALK_RIGHT: walk_right = 1;
            FALLING: aaah = 1;
            DIGGING: digging = 1;
        endcase
    end

endmodule