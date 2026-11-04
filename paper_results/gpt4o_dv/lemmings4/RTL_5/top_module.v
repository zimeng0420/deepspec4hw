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
    typedef enum logic [2:0] {
        S_WALK_LEFT    = 3'b000,
        S_WALK_RIGHT   = 3'b001,
        S_DIGGER_LEFT  = 3'b010,
        S_DIGGER_RIGHT = 3'b011,
        S_FALL_LEFT    = 3'b100,
        S_FALL_RIGHT   = 3'b101,
        S_SPLAT        = 3'b110
    } state_t;

    // State and falling counter registers
    state_t state, next_state;
    reg [4:0] fall_counter;  // For counting up to 21 (splat condition)

    // Asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_WALK_LEFT;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            if (aaah && ground)
                fall_counter <= 0;
            else if (aaah)
                fall_counter <= fall_counter + 1;
        end
    end

    // Next state logic and output assignments
    always_comb begin
        // Default assignments
        next_state = state;
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case (state)
            S_WALK_LEFT: begin
                if (!ground) begin
                    next_state = S_FALL_LEFT;
                    aaah = 1;
                end else if (dig) begin
                    next_state = S_DIGGER_LEFT;
                    digging = 1;
                end else if (bump_left) begin
                    next_state = S_WALK_RIGHT;
                    walk_right = 1;
                end else begin
                    walk_left = 1;
                end
            end

            S_WALK_RIGHT: begin
                if (!ground) begin
                    next_state = S_FALL_RIGHT;
                    aaah = 1;
                end else if (dig) begin
                    next_state = S_DIGGER_RIGHT;
                    digging = 1;
                end else if (bump_right) begin
                    next_state = S_WALK_LEFT;
                    walk_left = 1;
                end else begin
                    walk_right = 1;
                end
            end

            S_DIGGER_LEFT: begin
                if (!ground) begin
                    next_state = S_FALL_LEFT;
                    aaah = 1;
                end else begin
                    digging = 1;
                end
            end

            S_DIGGER_RIGHT: begin
                if (!ground) begin
                    next_state = S_FALL_RIGHT;
                    aaah = 1;
                end else begin
                    digging = 1;
                end
            end

            S_FALL_LEFT: begin
                aaah = 1;
                if (ground) begin
                    if (fall_counter >= 21) begin
                        next_state = S_SPLAT;
                    end else begin
                        next_state = S_WALK_LEFT;
                        walk_left = 1;
                    end
                end
            end

            S_FALL_RIGHT: begin
                aaah = 1;
                if (ground) begin
                    if (fall_counter >= 21) begin
                        next_state = S_SPLAT;
                    end else begin
                        next_state = S_WALK_RIGHT;
                        walk_right = 1;
                    end
                end
            end

            S_SPLAT: begin
                // Once splatted, remain in splat state with all outputs off
            end
        endcase 
    end
endmodule
