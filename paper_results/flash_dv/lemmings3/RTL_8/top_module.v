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
        if (areset) {
            current_walk_left <= 1;
            current_walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        } else begin
            // Falling
            if (!ground) {
                aaah <= 1;
                digging <= 0; // Stop digging when falling
            } else begin
                aaah <= 0;
                // Digging
                if (ground && dig) {
                    digging <= 1;
                } else {
                    digging <= 0;

                    // Bumped
                    if (bump_left || bump_right) {
                        current_walk_left <= current_walk_right;
                        current_walk_right <= current_walk_left;
                    }
                }
            }
        end
    end

    always @(*) begin
        walk_left = current_walk_left;
        walk_right = current_walk_right;
    end

endmodule