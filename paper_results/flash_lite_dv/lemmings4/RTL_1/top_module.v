module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg falling,
    output reg digging
);

    // State definition
    localparam WALKING_LEFT  = 0;
    localparam WALKING_RIGHT = 1;
    localparam FALLING       = 2;
    localparam DIGGING_LEFT  = 3;
    localparam DIGGING_RIGHT = 4;
    localparam SPLATTERED    = 5;

    // State register
    reg [2:0] state;

    // Internal registers
    reg [5:0] fall_count;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING_LEFT;
            walk_left <= 1;
            walk_right <= 0;
            falling <= 0;
            digging <= 0;
            fall_count <= 0;
        end else begin
            case (state)
                WALKING_LEFT: begin
                    walk_left <= 1;
                    walk_right <= 0;
                    falling <= 0;
                    digging <= 0;
                    fall_count <= 0;
                    if (ground == 0) begin
                        state <= FALLING;
                    end else if (dig && ground) begin
                        state <= DIGGING_LEFT;
                        digging <= 1;
                    end else if (bump_right) begin
                        state <= WALKING_RIGHT;
                    end
                end
                WALKING_RIGHT: begin
                    walk_left <= 0;
                    walk_right <= 1;
                    falling <= 0;
                    digging <= 0;
                    fall_count <= 0;
                    if (ground == 0) begin
                        state <= FALLING;
                    end else if (dig && ground) begin
                        state <= DIGGING_RIGHT;
                        digging <= 1;
                    end else if (bump_left) begin
                        state <= WALKING_LEFT;
                    end
                end
                FALLING: begin
                    walk_left <= 0;
                    walk_right <= 0;
                    falling <= 1;
                    digging <= 0;
                    if (ground) begin
                        if (fall_count > 20) begin
                            state <= SPLATTERED;
                            walk_left <= 0;
                            walk_right <= 0;
                            falling <= 0;
                            digging <= 0;
                            fall_count <= 0;
                        end else begin
                            if (walk_left)
                                state <= WALKING_LEFT;
                            else
                                state <= WALKING_RIGHT;
                            falling <= 0;
                            fall_count <= 0;
                        end
                    end else begin
                      fall_count <= fall_count + 1;
                    end
                end
                DIGGING_LEFT: begin
                    walk_left <= 0;
                    walk_right <= 0;
                    falling <= 0;
                    digging <= 1;
                    if (ground == 0) begin
                        state <= FALLING;
                    end
                end
                DIGGING_RIGHT: begin
                    walk_left <= 0;
                    walk_right <= 0;
                    falling <= 0;
                    digging <= 1;
                    if (ground == 0) begin
                        state <= FALLING;
                    end
                end
                SPLATTERED: begin
                    walk_left <= 0;
                    walk_right <= 0;
                    falling <= 0;
                    digging <= 0;
                    fall_count <= 0;
                end
                default: begin
                    state <= WALKING_LEFT;
                    walk_left <= 1;
                    walk_right <= 0;
                    falling <= 0;
                    digging <= 0;
                    fall_count <= 0;
                end
            endcase
        end
    end
endmodule