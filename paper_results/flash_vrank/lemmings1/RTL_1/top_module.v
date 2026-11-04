module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state; // 0: walk_left, 1: walk_right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
        end else begin
            if (bump_left) begin
                state <= 1;
            end else if (bump_right) begin
                state <= 0;
            end
        end
    end

    assign walk_left = (state == 0);
    assign walk_right = (state == 1);

endmodule