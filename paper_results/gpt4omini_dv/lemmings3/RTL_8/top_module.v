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

    // State Encoding
    typedef enum reg [1:0] {
        S_WALK_LEFT = 2'b00,
        S_WALK_RIGHT = 2'b01,
        S_FALLING = 2'b10,
        S_DIGGING = 2'b11
    } state_t;

    state_t current_state, next_state;

    // Asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S_WALK_LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic
    always @* begin
        case (current_state)
            S_WALK_LEFT: begin
                if (ground == 0) begin
                    next_state = S_FALLING;
                end else if (dig == 1) begin
                    next_state = S_DIGGING;
                end else if (bump_right == 1) begin
                    next_state = S_WALK_RIGHT;
                end else begin
                    next_state = S_WALK_LEFT;
                end
            end

            S_WALK_RIGHT: begin
                if (ground == 0) begin
                    next_state = S_FALLING;
                end else if (dig == 1) begin
                    next_state = S_DIGGING;
                end else if (bump_left == 1) begin
                    next_state = S_WALK_LEFT;
                end else begin
                    next_state = S_WALK_RIGHT;
                end
            end

            S_FALLING: begin
                if (ground == 1) begin
                    if (bump_left == 1) begin
                        next_state = S_WALK_RIGHT;
                    end else if (bump_right == 1) begin
                        next_state = S_WALK_LEFT;
                    end else begin
                        next_state = (walk_right ? S_WALK_RIGHT : S_WALK_LEFT);
                    end
                end else begin
                    next_state = S_FALLING;
                end
            end

            S_DIGGING: begin
                if (ground == 0) begin
                    next_state = S_FALLING;
                end else begin
                    next_state = S_DIGGING;
                end
            end

            default: next_state = S_WALK_LEFT;
        endcase
    end

    // Output Logic
    always @* begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (current_state)
            S_WALK_LEFT: begin
                walk_left = 1;
                digging = 0;
                aaah = 0;
            end

            S_WALK_RIGHT: begin
                walk_right = 1;
                digging = 0;
                aaah = 0;
            end

            S_FALLING: begin
                aaah = 1;
                digging = 0;
            end

            S_DIGGING: begin
                digging = 1;
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
            end
        endcase
    end
endmodule