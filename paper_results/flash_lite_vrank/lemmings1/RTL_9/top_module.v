module top_module (
	input clk,
	input areset,
	input bump_left,
	input bump_right,
	output walk_left,
	output walk_right
);

    parameter WALK_LEFT = 0;
    parameter WALK_RIGHT = 1;

    reg [0:0] state;

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

    assign walk_left = (state == WALK_LEFT) ? 1 : 0;
    assign walk_right = (state == WALK_RIGHT) ? 1 : 0;

endmodule