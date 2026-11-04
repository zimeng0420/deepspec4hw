module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg digging,
    output reg splat
);

    // State Definitions
    parameter WALK_LEFT = 2'b00;
    parameter WALK_RIGHT = 2'b01;
    parameter FALLING = 2'b10;
    parameter DIGGING = 2'b11;

    reg [1:0] state;
    reg [5:0] fall_counter;

    // Default values for outputs
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
            digging <= 1'b0;
            splat <= 1'b0;
            state <= WALK_LEFT;
            fall_counter <= 6'b0;
        end else begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
            digging <= 1'b0;
            splat <= 1'b0;

            case (state)
                WALK_LEFT: begin
                    if (bump_right) begin
                        state <= WALK_RIGHT;
                    end else if (ground == 1'b0) begin
                        state <= FALLING;
                        fall_counter <= 6'b0;
                    end else if (dig && ground) begin
                        state <= DIGGING;
                        digging <= 1'b1;
                    end else begin
                        walk_left <= 1'b1;
                    end
                end
                WALK_RIGHT: begin
                    if (bump_left) begin
                        state <= WALK_LEFT;
                    end else if (ground == 1'b0) begin
                        state <= FALLING;
                        fall_counter <= 6'b0;
                    end else if (dig && ground) begin
                        state <= DIGGING;
                        digging <= 1'b1;
                    end else begin
                        walk_right <= 1'b1;
                    end
                end
                FALLING: begin
                    fall_counter <= fall_counter + 1'b1;
                    if (ground) begin
                        if (fall_counter > 20) begin
                            splat <= 1'b1;
                            state <= FALLING; // Stay in falling state
                        end else begin
                            if (walk_left) begin
                                state <= WALK_LEFT;
                            end else begin
                                state <= WALK_RIGHT;
                            end
                        end
                    end else begin
                        state <= FALLING; // Stay in falling state
                    end
                end
                DIGGING: begin
                    if (ground == 1'b0) begin
                        state <= FALLING;
                        fall_counter <= 6'b0;
                    end else begin
                        digging <= 1'b1;
                        if(walk_left)
                            walk_left <= 1'b1;
                        else if (walk_right)
                            walk_right <= 1'b1;
                    end

                end
            endcase
            if(splat) begin
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                digging <= 1'b0;
            end
        end
    end

endmodule