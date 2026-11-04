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

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT_STATE;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            WALK_LEFT_STATE: begin
                if (bump_left)
                    next_state = WALK_RIGHT_STATE;
                else if (bump_right)
                    next_state = WALK_RIGHT_STATE;
                else
                    next_state = WALK_LEFT_STATE;
            end
            WALK_RIGHT_STATE: begin
                if (bump_left)
                    next_state = WALK_RIGHT_STATE;
                else if (bump_right)
                    next_state = WALK_LEFT_STATE;
                else
                    next_state = WALK_RIGHT_STATE;
            end
            default:
                next_state = WALK_LEFT_STATE;
        endcase
    end

    assign walk_left = (state == WALK_LEFT_STATE);
    assign walk_right = (state == WALK_RIGHT_STATE);

endmodule