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

    // State Definitions
    parameter WALK_LEFT  = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALLING    = 2'b10;

    // State Register
    reg [1:0] current_state;
    reg [1:0] next_state;

    // State Transition Logic (Next State Logic)
    always @(*) begin
        case (current_state)
            WALK_LEFT:  begin
                if (bump_right)
                    next_state = WALK_LEFT; // Stay in WALK_LEFT if bumped on right (as it doesn't affect current direction) - for spec
                else if (!ground)
                    next_state = FALLING;
                else if (bump_left)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;

            end
            WALK_RIGHT: begin
                if (bump_left)
                    next_state = WALK_RIGHT; // Stay in WALK_RIGHT if bumped on left (as it doesn't affect current direction) - for spec
                else if (!ground)
                    next_state = FALLING;
                else if (bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end
            FALLING: begin
                if (ground)
                begin
                    if (walk_left)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;

                end
                else
                    next_state = FALLING; // stay in falling if not on ground
            end
            default: next_state = WALK_LEFT; // Default case - should never happen, but good practice.
        endcase
    end

    // State Update Logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= WALK_LEFT;
        else
            current_state <= next_state;
    end

    // Output Logic (Moore Machine)
    always @(*) begin
        case (current_state)
            WALK_LEFT:  begin
                walk_left  = 1;
                walk_right = 0;
                aaah       = 0;
            end
            WALK_RIGHT: begin
                walk_left  = 0;
                walk_right = 1;
                aaah       = 0;
            end
            FALLING:    begin
                walk_left  = 0;
                walk_right = 0;
                aaah       = 1;
            end
            default:    begin
                walk_left  = 1; // Default to walking left
                walk_right = 0;
                aaah       = 0;
            end
        endcase
    end

endmodule