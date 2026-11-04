module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    reg [2:0] state;
    parameter WALK_LEFT = 3'b001;
    parameter WALK_RIGHT = 3'b010;
    parameter FALLING = 3'b100;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (!ground) begin
                        state <= FALLING;
                    end else if (bump_left || (bump_left && bump_right) || bump_right) begin
                        state <= WALK_RIGHT;
                    end else begin
                        state <= WALK_LEFT;
                    end
                end
                WALK_RIGHT: begin
                    if (!ground) begin
                        state <= FALLING;
                    end else if (bump_right || (bump_left && bump_right) || bump_left) begin
                        state <= WALK_LEFT;
                    end else begin
                        state <= WALK_RIGHT;
                    end
                end
                FALLING: begin
                    if (ground) begin
                        // Retain previous walking direction
                        if (walk_left)
                            state <= WALK_LEFT;
                        else
                            state <= WALK_RIGHT;
                    end else begin
                        state <= FALLING;
                    end
                end
                default: state <= WALK_LEFT; // Should not happen, but good practice
            endcase
        end
    end

    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALLING);

endmodule