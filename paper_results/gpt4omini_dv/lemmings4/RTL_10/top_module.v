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

    reg [1:0] state; // 00: walking left, 01: walking right, 10: falling, 11: digging
    reg [4:0] fall_count; // Count falling cycles

    localparam WALK_LEFT = 2'b00,
               WALK_RIGHT = 2'b01,
               FALLING = 2'b10,
               DIGGING = 2'b11;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
            fall_count <= 0;
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (!ground) begin
                        state <= FALLING;
                        aaah <= 1;
                        walk_left <= 0;
                        walk_right <= 0;
                        fall_count <= 1;
                    end else if (dig) begin
                        state <= DIGGING;
                        digging <= 1;
                    end else if (bump_right) begin
                        state <= WALK_RIGHT;
                        walk_left <= 0;
                        walk_right <= 1;
                    end
                end
                
                WALK_RIGHT: begin
                    if (!ground) begin
                        state <= FALLING;
                        aaah <= 1;
                        walk_left <= 0;
                        walk_right <= 0;
                        fall_count <= 1;
                    end else if (dig) begin
                        state <= DIGGING;
                        digging <= 1;
                    end else if (bump_left) begin
                        state <= WALK_LEFT;
                        walk_left <= 1;
                        walk_right <= 0;
                    end
                end
                
                FALLING: begin
                    if (ground) begin
                        if (fall_count > 20) begin
                            walk_left <= 0;
                            walk_right <= 0;
                            aaah <= 0;
                            digging <= 0;
                        end else begin
                            // Resume walking in the last direction
                            case (state)
                                WALK_LEFT: begin
                                    state <= WALK_LEFT;
                                    walk_left <= 1;
                                    walk_right <= 0;
                                end
                                WALK_RIGHT: begin
                                    state <= WALK_RIGHT;
                                    walk_left <= 0;
                                    walk_right <= 1;
                                end
                            endcase
                        end
                    end else begin
                        fall_count <= fall_count + 1; // Increment fall count
                    end
                    aaah <= 1; // Falling state
                end
                
                DIGGING: begin
                    if (!ground) begin
                        state <= FALLING;
                        aaah <= 1;
                        walk_left <= 0;
                        walk_right <= 0;
                        fall_count <= 1;
                    end
                    // Continue digging until ground reappears
                end

                default: begin
                    state <= WALK_LEFT;
                end
            endcase
        end
    end

    always @* begin
        if (state == DIGGING) begin
            digging <= 1;
        end else begin
            digging <= 0;
        end
    end

endmodule