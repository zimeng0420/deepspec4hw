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

    // Define states
    localparam WALK_LEFT = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL = 2'b10;
    localparam DIG = 2'b11;
    localparam SPLAT = 2'b11; // Use DIG as SPLAT to avoid adding more states.
                                 //When splat, all outputs are zero so no conflict.

    reg [1:0] current_state, next_state;
    reg [4:0] fall_counter;

    // Output signals
    reg w_left, w_right, a, d;
    assign walk_left = w_left;
    assign walk_right = w_right;
    assign aaah = a;
    assign digging = d;


    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
            fall_counter <= 0;
            w_left <= 1;
            w_right <= 0;
            a <= 0;
            d <= 0;

        end else begin
            current_state <= next_state;
            w_left <= (next_state == WALK_LEFT);
            w_right <= (next_state == WALK_RIGHT);
            a <= (next_state == FALL);
            d <= (next_state == DIG);
            if (next_state == FALL && current_state == FALL) begin
                fall_counter <= fall_counter + 1;
            end else if(next_state != FALL) begin
                fall_counter <= 0;
            end


        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state; // Default: Stay in the current state

        case (current_state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_left || (bump_left && bump_right) || bump_right) begin
                    next_state = WALK_RIGHT;
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_right || (bump_left && bump_right) || bump_left) begin
                    next_state = WALK_LEFT;
                end
            end

            FALL: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = SPLAT; // Splatter
                    end else begin
                        if(w_left)
                            next_state = WALK_LEFT;
                        else
                            next_state = WALK_RIGHT;
                    end
                end
            end

            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                end
            end

            SPLAT: begin
                next_state = SPLAT;
                w_left = 0;
                w_right = 0;
                a = 0;
                d = 0;
            end

            default: begin
                next_state = WALK_LEFT;
            end
        endcase
    end

endmodule