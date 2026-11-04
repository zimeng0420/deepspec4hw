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

    // State Definition
    localparam WALK_LEFT_STATE  = 2'b00;
    localparam WALK_RIGHT_STATE = 2'b01;
    localparam FALLING_STATE    = 2'b10;
    localparam DIGGING_STATE    = 2'b11;

    // State Register
    reg [1:0] current_state;
    reg [1:0] next_state;

    // Fall Counter
    reg [4:0] fall_counter;

    // Splatter Flag
    reg splatter;

    // Output Registers
    reg walk_left_reg;
    reg walk_right_reg;
    reg aaah_reg;
    reg digging_reg;

    // Assign outputs
    assign walk_left = walk_left_reg;
    assign walk_right = walk_right_reg;
    assign aaah = aaah_reg;
    assign digging = digging_reg;

    // State Transition Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT_STATE;
            fall_counter <= 0;
            splatter <= 0;
            walk_left_reg <= 1;
            walk_right_reg <= 0;
            aaah_reg <= 0;
            digging_reg <= 0;
        end else begin
            current_state <= next_state;
            walk_left_reg <= (splatter == 0) ? ((current_state == WALK_LEFT_STATE) ? 1 : 0) : 0;
            walk_right_reg <= (splatter == 0) ? ((current_state == WALK_RIGHT_STATE) ? 1 : 0) : 0;
            aaah_reg <= (splatter == 0) ? ((current_state == FALLING_STATE) ? 1 : 0) : 0;
            digging_reg <= (splatter == 0) ? ((current_state == DIGGING_STATE) ? 1 : 0) : 0;

            if (current_state == FALLING_STATE) begin
                if (ground == 0) begin
                    if (fall_counter < 20) begin
                        fall_counter <= fall_counter + 1;
                    end
                end else begin
                    if (fall_counter >= 20) begin
                        splatter <= 1;
                    end
                    fall_counter <= 0;
                end
            end
        end
    end

    // Next State Logic
    always @(*) begin
        next_state = current_state; // Default: Stay in the same state

        if (splatter) begin
            next_state = current_state; // Lemming is dead, no state change
        end else if (ground == 0) begin
            next_state = FALLING_STATE;
        end else if (current_state == FALLING_STATE && ground == 1) begin
            if (walk_left_reg)
                next_state = WALK_LEFT_STATE;
            else
                next_state = WALK_RIGHT_STATE;
        end else if (dig && ground) begin
            next_state = DIGGING_STATE;
        end else if (current_state == DIGGING_STATE && ground == 0) begin
            next_state = FALLING_STATE;
        end
        else if (current_state != FALLING_STATE && current_state != DIGGING_STATE) begin
            if (bump_left || bump_right) begin
                if (current_state == WALK_LEFT_STATE)
                    next_state = WALK_RIGHT_STATE;
                else
                    next_state = WALK_LEFT_STATE;
            end
        end
    end

endmodule