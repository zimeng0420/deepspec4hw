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
    reg [1:0] state;

    // Next State Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (bump_left)
                        state <= WALK_RIGHT;
                    else if (!ground)
                        state <= FALLING;
                    else
                        state <= WALK_LEFT;
                end
                WALK_RIGHT: begin
                    if (bump_right)
                        state <= WALK_LEFT;
                    else if (!ground)
                        state <= FALLING;
                    else
                        state <= WALK_RIGHT;
                end
                FALLING: begin
                    if (ground)
                    begin
                        if(walk_left)
                            state <= WALK_LEFT;
                        else
                            state <= WALK_RIGHT;
                    end
                    else
                        state <= FALLING;
                end
                default: state <= WALK_LEFT;
            endcase
        end
    end

    // Output Logic (Moore Machine)
    always @(*) begin
        case (state)
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
                aaah       = 0;
            end
        endcase
    end

endmodule