module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // State Definition
    parameter WALK_LEFT = 0;
    parameter WALK_RIGHT = 1;

    // State Register
    reg [1:0] state;  // Using 2 bits to define the states as Moore Machine with two states

    // Next State Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (bump_right) begin
                        state <= WALK_RIGHT;
                    end
                end
                WALK_RIGHT: begin
                    if (bump_left) begin
                        state <= WALK_LEFT;
                    end
                end
            endcase
        end
    end

    // Output Logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                walk_left = 1;
                walk_right = 0;
            end
            WALK_RIGHT: begin
                walk_left = 0;
                walk_right = 1;
            end
            default: begin
                walk_left = 1; // Default to WALK_LEFT state if state is invalid
                walk_right = 0;
            end
        endcase
    end

endmodule