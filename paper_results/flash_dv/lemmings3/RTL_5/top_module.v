module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    reg current_walk_left;
    reg current_walk_right;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_walk_left <= 1;
            current_walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end else begin
            aaah <= !ground;
            digging <= ground & dig;

            if (!ground) begin
                // Falling: maintain walking direction
            end else if (ground & dig) begin
                // Digging: maintain walking direction
            end else if (bump_left | bump_right) begin
                // Bumped: switch direction
                current_walk_left <= current_walk_right;
                current_walk_right <= current_walk_left;
            end else begin
                // No change in direction
            end
        end
    end

    always @(*) begin
        walk_left = current_walk_left;
        walk_right = current_walk_right;
    end

endmodule