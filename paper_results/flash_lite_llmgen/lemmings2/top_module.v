module top_module (
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

    // State Register
    reg [1:0] state, next_state;

    // Combinational Logic for Next State and Outputs
    always @(*) begin
        next_state = state;
        walk_left = 0;
        walk_right = 0;
        aaah = 0;

        case (state)
            WALK_LEFT: begin
                walk_left = 1;
                if (bump_left) begin
                    next_state = WALK_RIGHT;
                end
                if (!ground) begin
                    next_state = FALLING;
                end
            end
            WALK_RIGHT: begin
                walk_right = 1;
                if (bump_right) begin
                    next_state = WALK_LEFT;
                end
                if (!ground) begin
                    next_state = FALLING;
                end
            end
            FALLING: begin
                aaah = 1;
                if (ground) begin
                    if (state == FALLING) begin // Check if the state is still falling
                        if (walk_left) begin
                            next_state = WALK_LEFT;
                        end else if (walk_right) begin
                            next_state = WALK_RIGHT;
                        end
                    end
                end
            end
            default: begin
                next_state = WALK_LEFT; // Default to WALK_LEFT for safety
            end
        endcase
    end

    // Sequential Logic for State Update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

endmodule