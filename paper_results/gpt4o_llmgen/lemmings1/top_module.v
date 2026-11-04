module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    reg state, next_state;
    parameter STATE_LEFT = 0, STATE_RIGHT = 1;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_LEFT; // On areset, set to walk left
        end else begin
            state <= next_state; // Update state on clock edge
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            STATE_LEFT: begin
                if (bump_left || bump_right)
                    next_state = STATE_RIGHT; // Switch to walking right
                else
                    next_state = STATE_LEFT; // Continue walking left
            end
            STATE_RIGHT: begin
                if (bump_left || bump_right)
                    next_state = STATE_LEFT; // Switch to walking left
                else
                    next_state = STATE_RIGHT; // Continue walking right
            end
        endcase
    end

    // Output logic (Moore machine)
    assign walk_left = (state == STATE_LEFT);
    assign walk_right = (state == STATE_RIGHT);

endmodule