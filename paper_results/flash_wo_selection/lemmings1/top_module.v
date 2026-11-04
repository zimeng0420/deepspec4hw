module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg current_walk_left;
    reg current_walk_right;

    always @(posedge areset or posedge clk) begin
        if (areset) begin
            current_walk_left <= 1;
            current_walk_right <= 0;
        end else begin
            if (current_walk_left) begin
                if (bump_left || bump_right) begin
                    current_walk_left <= 0;
                    current_walk_right <= 1;
                end
            end else begin // current_walk_right
                if (bump_left || bump_right) begin
                    current_walk_left <= 1;
                    current_walk_right <= 0;
                end
            end
        end
    end

    assign walk_left = current_walk_left;
    assign walk_right = current_walk_right;

endmodule