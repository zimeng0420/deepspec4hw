module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg current_state;
    reg next_state;

    // State definition
    localparam LEFT = 1'b1;
    localparam RIGHT = 1'b0;

    // State transition logic
    always @(*) begin
        case (current_state)
            LEFT: begin
                if (bump_left) begin
                    next_state = RIGHT;
                end else if (bump_right) begin
                    next_state = RIGHT;
                end else begin
                    next_state = LEFT;
                end
            end
            RIGHT: begin
                if (bump_right) begin
                    next_state = LEFT;
                end else if (bump_left) begin
                    next_state = LEFT;
                end else begin
                    next_state = RIGHT;
                end
            end
            default: next_state = LEFT; // Should never happen, but good practice
        endcase
    end

    // State update logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    // Output logic
    assign walk_left = (current_state == LEFT);
    assign walk_right = (current_state == RIGHT);

endmodule