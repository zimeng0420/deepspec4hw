module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg current_state; // 0: walk_left, 1: walk_right
    parameter LEFT = 0, RIGHT = 1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= LEFT;
        end else begin
            if (bump_left) begin
                current_state <= RIGHT;
            end else if (bump_right) begin
                current_state <= LEFT;
            end
        end
    end

    assign walk_left = (current_state == LEFT);
    assign walk_right = (current_state == RIGHT);

endmodule