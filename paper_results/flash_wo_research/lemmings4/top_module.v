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

    // State definition
    typedef enum logic [2:0] {
        WALKING_LEFT,
        WALKING_RIGHT,
        FALLING,
        DIGGING,
        SPLATTERED
    } state_t;

    // State variable
    reg state;

    // Falling counter
    reg [4:0] fall_counter;

    // Output signals
    reg walk_left_r;
    reg walk_right_r;
    reg aaah_r;
    reg digging_r;

    // Assign outputs
    assign walk_left = walk_left_r;
    assign walk_right = walk_right_r;
    assign aaah = aaah_r;
    assign digging = digging_r;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING_LEFT;
            fall_counter <= 0;
            walk_left_r <= 1;
            walk_right_r <= 0;
            aaah_r <= 0;
            digging_r <= 0;
        end else begin
            case (state)
                WALKING_LEFT: begin
                    walk_left_r <= 1;
                    walk_right_r <= 0;
                    aaah_r <= 0;
                    digging_r <= 0;

                    if (!ground) begin
                        state <= FALLING;
                        fall_counter <= 0;
                        aaah_r <= 1;
                        digging_r <= 0;
                        walk_left_r <= 0;
                        walk_right_r <= 0;
                    end else if (dig) begin
                        state <= DIGGING;
                        digging_r <= 1;
                        walk_left_r <= 0;
                        walk_right_r <= 0;
                        aaah_r <= 0;
                    end else if (bump_left || bump_right) begin
                        state <= WALKING_RIGHT;
                        walk_left_r <= 0;
                        walk_right_r <= 1;
                        aaah_r <= 0;
                        digging_r <= 0;
                    end
                end

                WALKING_RIGHT: begin
                    walk_left_r <= 0;
                    walk_right_r <= 1;
                    aaah_r <= 0;
                    digging_r <= 0;

                    if (!ground) begin
                        state <= FALLING;
                        fall_counter <= 0;
                        aaah_r <= 1;
                        digging_r <= 0;
                        walk_left_r <= 0;
                        walk_right_r <= 0;
                    end else if (dig) begin
                        state <= DIGGING;
                        digging_r <= 1;
                        walk_left_r <= 0;
                        walk_right_r <= 0;
                        aaah_r <= 0;
                    end else if (bump_left || bump_right) begin
                        state <= WALKING_LEFT;
                        walk_left_r <= 1;
                        walk_right_r <= 0;
                        aaah_r <= 0;
                        digging_r <= 0;
                    end
                end

                FALLING: begin
                    walk_left_r <= 0;
                    walk_right_r <= 0;
                    aaah_r <= 1;
                    digging_r <= 0;

                    if (!ground) begin
                        if (fall_counter < 21) begin
                            fall_counter <= fall_counter + 1;
                        end
                    end else begin
                        if (fall_counter >= 20) begin
                            state <= SPLATTERED;
                            walk_left_r <= 0;
                            walk_right_r <= 0;
                            aaah_r <= 0;
                            digging_r <= 0;
                            fall_counter <= 0;
                        end else begin
                            if (walk_left_r == 1) begin
                                state <= WALKING_LEFT;
                                walk_left_r <= 1;
                                walk_right_r <= 0;
                                aaah_r <= 0;
                                digging_r <= 0;
                                fall_counter <= 0;
                            end else begin
                                state <= WALKING_RIGHT;
                                walk_left_r <= 0;
                                walk_right_r <= 1;
                                aaah_r <= 0;
                                digging_r <= 0;
                                fall_counter <= 0;
                            end
                        end
                    end
                end

                DIGGING: begin
                    walk_left_r <= 0;
                    walk_right_r <= 0;
                    aaah_r <= 0;
                    digging_r <= 1;

                    if (!ground) begin
                        state <= FALLING;
                        fall_counter <= 0;
                        aaah_r <= 1;
                        digging_r <= 0;
                        walk_left_r <= 0;
                        walk_right_r <= 0;
                    end
                end

                SPLATTERED: begin
                    walk_left_r <= 0;
                    walk_right_r <= 0;
                    aaah_r <= 0;
                    digging_r <= 0;
                end
            endcase
        end
    end

endmodule