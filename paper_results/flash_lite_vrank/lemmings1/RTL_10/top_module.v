module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    parameter WALK_LEFT_STATE = 0;
    parameter WALK_RIGHT_STATE = 1;

    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            WALK_LEFT_STATE: begin
                if (bump_left || bump_right)
                    next_state = WALK_RIGHT_STATE;
                else
                    next_state = WALK_LEFT_STATE;
            end
            WALK_RIGHT_STATE: begin
                if (bump_left || bump_right)
                    next_state = WALK_LEFT_STATE;
                else
                    next_state = WALK_RIGHT_STATE;
            end
            default: next_state = WALK_LEFT_STATE;
        endcase
    end

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT_STATE;
        else
            state <= next_state;
    end

    // Output logic
    always @(*) begin
        if (state == WALK_LEFT_STATE) begin
            walk_left = 1;
            walk_right = 0;
        end else begin
            walk_left = 0;
            walk_right = 1;
        end
    end

endmodule