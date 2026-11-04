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

    // State Definition
    parameter IDLE = 2'b00;
    parameter WALKING_LEFT = 2'b01;
    parameter WALKING_RIGHT = 2'b10;
    parameter FALLING = 2'b11;

    reg [1:0] state, next_state;

    // State Register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALKING_LEFT; // Reset to walk left
        else
            state <= next_state;
    end

    // Combinational Logic for Next State and Outputs
    always @(*) begin
        // Default values
        next_state = state;
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (state)
            IDLE: begin
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    digging = 1;
                    if (walk_left)
                      next_state = WALKING_LEFT;
                    else
                      next_state = WALKING_RIGHT;
                end else if (bump_left) begin
                    next_state = WALKING_RIGHT;
                end else if (bump_right) begin
                    next_state = WALKING_LEFT;
                end else if (walk_left) begin
                    walk_left = 1;
                    next_state = WALKING_LEFT;
                end else if (walk_right) begin
                    walk_right = 1;
                    next_state = WALKING_RIGHT;
                end else begin
                    walk_left = 1;
                    next_state = WALKING_LEFT;  // Default to walk left if nothing else
                end
            end

            WALKING_LEFT: begin
                walk_left = 1;
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    digging = 1;
                end else if (bump_right) begin
                    next_state = WALKING_RIGHT;
                end
            end

            WALKING_RIGHT: begin
                walk_right = 1;
                if (!ground) begin
                    next_state = FALLING;
                    aaah = 1;
                end else if (dig) begin
                    digging = 1;
                end else if (bump_left) begin
                    next_state = WALKING_LEFT;
                end
            end

            FALLING: begin
                aaah = 1;
                if (ground)
                    next_state = (walk_left) ? WALKING_LEFT : WALKING_RIGHT;
            end
            
            default: begin
                next_state = IDLE;
                walk_left = 1;
            end
        endcase
    end

endmodule