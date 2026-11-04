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
            
            if (ground && dig) begin
                digging_r <= 1;
            end else if (!ground) begin
                digging_r <= 0;
            end
            
            if (!ground) begin
                // Falling: maintain previous walking direction
            end else if (ground && dig) begin
                //Digging: maintain previous walking direction
            end
            else if (bump_left || bump_right) begin
                // Bumping: switch direction
                walk_left_r <= walk_right_r;
                walk_right_r <= walk_left_r;
            end else begin
                // No change: maintain previous walking direction
            end
            
            if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (!(bump_left || bump_right)) begin
                //maintain the direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            
            
            if (!(ground && dig) && !(!ground) && !(bump_left || bump_right)) begin
                //maintain the walking direction
            end
            
            if(ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if(areset) begin
                //do nothing, already handled above
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(ground && dig) && !(!ground) && !(bump_left || bump_right) && !areset) begin
                //do nothing, already maintained
            end
            
            if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (!(ground && dig) && !(!ground) && !(bump_left || bump_right)) begin
                //do nothing, already maintained
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing, falling
            end
            else if (bump_left || bump_right) begin
                //do nothing, already handled above
            end
            else begin
                //maintain walking direction
            end
            
            if (!(areset || (ground && dig) || !ground || (bump_left || bump_right))) begin
                //maintain walking direction
            end
            else if (areset) begin
                walk_left_r <= 1;
                walk_right_r <= 0;
            end
            else if (ground && dig) begin
                //do nothing, digging
            end
            else if (!ground) begin
                //do nothing,