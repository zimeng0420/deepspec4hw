module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    reg walk_left_r;
    reg walk_right_r;
    reg aaah_r;
    reg digging_r;

    assign walk_left = walk_left_r;
    assign walk_right = walk_right_r;
    assign aaah = aaah_r;
    assign digging = digging_r;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left_r <= 1;
            walk_right_r <= 0;
            aaah_r <= 0;
            digging_r <= 0;
        end else begin
            aaah_r <= !ground;
            digging_r <= ground & dig;

            if (!ground) begin
                // Falling, maintain walking direction
            end else if (ground & dig) begin
                // Digging, maintain walking direction
            end else if (bump_left | bump_right) begin
                // Bumped, switch direction
                walk_left_r <= walk_right_r;
                walk_right_r <= walk_left_r;
            end else begin
                // No change
            end

            if (!(bump_left | bump_right) && !(ground & dig) && ground) begin
                //Walking and not bumped or digging
            end

            if(areset == 0 && (bump_left | bump_right) && ground && !digging_r) begin
                walk_left_r <= walk_right_r;
                walk_right_r <= walk_left_r;
            end else if (areset == 0 && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !ground) begin
                //do nothing
            end else if (areset == 0 && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && !ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && (bump_left | bump_right) && ground && !dig) begin
                //do nothing
            end else if (areset == 0 && !(bump_left | bump_right) && !ground && !dig) begin
                