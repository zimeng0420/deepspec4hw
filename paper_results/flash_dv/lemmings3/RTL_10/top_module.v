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

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left_r <= 1'b1;
            walk_right_r <= 1'b0;
            aaah_r <= 1'b0;
            digging_r <= 1'b0;
        end else begin
            // aaah
            aaah_r <= !ground;

            // digging
            if (ground && dig && !aaah_r) begin
                digging_r <= 1'b1;
            end else if (!ground) begin
                digging_r <= 1'b0;
            end
            
            // walking direction
            if (!ground) begin
                // Falling, maintain direction
            end else if (ground && dig && !aaah_r) begin
                // Digging, maintain direction
            end else if (bump_left || bump_right) {
                walk_left_r <= walk_right_r;
                walk_right_r <= walk_left_r;
                digging_r <= 1'b0;
            } else begin
                // Maintain direction
            end
        end
    end

    assign walk_left = walk_left_r;
    assign walk_right = walk_right_r;
    assign aaah = aaah_r;
    assign digging = digging_r;

endmodule