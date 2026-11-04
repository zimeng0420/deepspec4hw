module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // State Definition
    parameter WALK_LEFT  = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALLING    = 2'b10;

    // State Variable
    reg [1:0] current_state, next_state;

    // State Transition Logic
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                if (bump_right) begin
                    next_state = WALK_LEFT; // Stay left (no effect of bump)
                end else if (bump_left) begin
                    next_state = WALK_RIGHT;
                end else if (!ground) begin
                    next_state = FALLING;
                end else begin
                    next_state = WALK_LEFT; // Stay Left
                end
            end
            WALK_RIGHT: begin
                if (bump_left) begin
                    next_state = WALK_RIGHT; //stay right (no effect of bump)
                end else if (bump_right) begin
                    next_state = WALK_LEFT;
                end else if (!ground) begin
                    next_state = FALLING;
                end else begin
                   next_state = WALK_RIGHT; //Stay right
                end
            end
            FALLING: begin
                if (ground) begin
                    if (current_state == FALLING) begin
                         if(walk_left) begin
                            next_state = WALK_LEFT;
                         end else begin
                            next_state = WALK_RIGHT;
                         end
                    end
                end else begin
                    next_state = FALLING; // Stay Falling
                end
            end
            default: next_state = WALK_LEFT; // Default to walk left (shouldn't happen)
        endcase
    end

    // State Register
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= WALK_LEFT;
        else
            current_state <= next_state;
    end

    // Output Logic
    always @(*) begin
        case (current_state)
            WALK_LEFT: begin
                walk_left  = 1;
                walk_right = 0;
                aaah       = 0;
            end
            WALK_RIGHT: begin
                walk_left  = 0;
                walk_right = 1;
                aaah       = 0;
            end
            FALLING: begin
                walk_left  = 0;
                walk_right = 0;
                aaah       = 1;
            end
            default: begin
                walk_left  = 1;
                walk_right = 0;
                aaah       = 0; // Default to walking left
            end
        endcase
    end

endmodule