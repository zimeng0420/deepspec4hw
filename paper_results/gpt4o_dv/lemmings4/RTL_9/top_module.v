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
    // Define state encoding
    typedef enum reg [3:0] {
        STATE_WALK_LEFT = 4'b0001,
        STATE_WALK_RIGHT = 4'b0010,
        STATE_FALL_LEFT = 4'b0100,
        STATE_FALL_RIGHT = 4'b1000,
        STATE_DIG_LEFT = 4'b0011,
        STATE_DIG_RIGHT = 4'b0110,
        STATE_SPLATTERED = 4'b0000
    } lemming_state_t;

    reg [3:0] state, next_state;
    reg [5:0] fall_counter; // 6-bit counter to track falling duration

    // State transition logic
    always @(*) begin
        case (state)
            STATE_WALK_LEFT: begin
                if (!ground) begin
                    next_state = STATE_FALL_LEFT;
                end
                else if (dig) begin
                    next_state = STATE_DIG_LEFT;
                end
                else if (bump_left) begin
                    next_state = STATE_WALK_RIGHT;
                end
                else begin
                    next_state = STATE_WALK_LEFT;
                end
            end
            STATE_WALK_RIGHT: begin
                if (!ground) begin
                    next_state = STATE_FALL_RIGHT;
                end
                else if (dig) begin
                    next_state = STATE_DIG_RIGHT;
                end
                else if (bump_right) begin
                    next_state = STATE_WALK_LEFT;
                end
                else begin
                    next_state = STATE_WALK_RIGHT;
                end
            end
            STATE_FALL_LEFT: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = STATE_SPLATTERED;
                    end
                    else begin
                        next_state = STATE_WALK_LEFT;
                    end
                end
                else begin
                    next_state = STATE_FALL_LEFT;
                end
            end
            STATE_FALL_RIGHT: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = STATE_SPLATTERED;
                    end
                    else begin
                        next_state = STATE_WALK_RIGHT;
                    end
                end
                else begin
                    next_state = STATE_FALL_RIGHT;
                end
            end
            STATE_DIG_LEFT: begin
                if (!ground) begin
                    next_state = STATE_FALL_LEFT;
                end
                else begin
                    next_state = STATE_DIG_LEFT;
                end
            end
            STATE_DIG_RIGHT: begin
                if (!ground) begin
                    next_state = STATE_FALL_RIGHT;
                end
                else begin
                    next_state = STATE_DIG_RIGHT;
                end
            end
            STATE_SPLATTERED: begin
                next_state = STATE_SPLATTERED; // Remain splattered
            end
            default: next_state = STATE_WALK_LEFT;
        endcase
    end

    // State flip-flops and counter
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_WALK_LEFT;
            fall_counter <= 0;
        end
        else begin
            state <= next_state;
            if ((state == STATE_FALL_LEFT) || (state == STATE_FALL_RIGHT)) begin
                fall_counter <= fall_counter + 1;
            end
            else begin
                fall_counter <= 0;
            end
        end
    end

    // Output logic
    always @(*) begin
        // Default all outputs to 0
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        case (state)
            STATE_WALK_LEFT: walk_left = 1;
            STATE_WALK_RIGHT: walk_right = 1;
            STATE_FALL_LEFT, STATE_FALL_RIGHT: aaah = 1;
            STATE_DIG_LEFT: digging = 1;
            STATE_DIG_RIGHT: digging = 1;
            STATE_SPLATTERED: ; // All outputs remain 0
        endcase
    end
endmodule