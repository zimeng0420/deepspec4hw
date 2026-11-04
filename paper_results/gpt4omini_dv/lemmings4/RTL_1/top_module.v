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

    reg [1:0] state; // 00 = walk left, 01 = walk right, 10 = falling, 11 = digging
    reg [4:0] fall_count; // 5-bit counter to track falling cycles

    // State encoding
    localparam WALK_LEFT = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALLING = 2'b10;
    localparam DIGGING = 2'b11;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_count <= 0;
        end else begin
            case (state)
                WALK_LEFT: begin
                    if (ground == 0) begin
                        aaah <= 1;
                        fall_count <= fall_count + 1;
                        state <= FALLING;
                    end else if (dig) begin
                        state <= DIGGING;
                    end else if (bump_right) begin
                        walk_left <= 0;
                        walk_right <= 1;
                    end else begin
                        walk_left <= 1;
                        walk_right <= 0;
                    end
                    aaah <= 0;
                    digging <= 0;
                end
                
                WALK_RIGHT: begin
                    if (ground == 0) begin
                        aaah <= 1;
                        fall_count <= fall_count + 1;
                        state <= FALLING;
                    end else if (dig) begin
                        state <= DIGGING;
                    end else if (bump_left) begin
                        walk_left <= 1;
                        walk_right <= 0;
                    end else begin
                        walk_left <= 0;
                        walk_right <= 1;
                    end
                    aaah <= 0;
                    digging <= 0;
                end
                
                FALLING: begin
                    if (ground == 1) begin
                        if (fall_count > 20) begin
                            walk_left <= 0;
                            walk_right <= 0;
                            aaah <= 0;
                            digging <= 0;
                            state <= WALK_LEFT; // reset to any state does not matter after splatter
                        end else begin
                            fall_count <= 0; // Reset fall count when hitting ground
                            state <= (bump_left ? WALK_RIGHT : WALK_LEFT);
                        end
                    end else begin
                        aaah <= 1;
                        fall_count <= fall_count + 1; // continue to count falling
                    end
                end
                
                DIGGING: begin
                    if (ground == 0) begin
                        aaah <= 1; 
                        state <= FALLING; // fall after digging
                    end else begin
                        digging <= 1;
                        walk_left <= 0;
                        walk_right <= 0;
                    end
                    aaah <= 0; 
                end
            endcase
        end
    end

endmodule