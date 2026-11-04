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
    localparam S_WALK_LEFT = 3'b001;
    localparam S_WALK_RIGHT = 3'b010;
    localparam S_FALL = 3'b011;
    localparam S_DIG = 3'b100;
    localparam S_SPLAT = 3'b101;

    reg [2:0] current_state, next_state;
    reg [4:0] fall_count;

    // Output signals
    assign walk_left = (current_state == S_WALK_LEFT);
    assign walk_right = (current_state == S_WALK_RIGHT);
    assign aaah = (current_state == S_FALL);
    assign digging = (current_state == S_DIG);

    // State transition logic
    always @(*) begin
        next_state = current_state; // Default: stay in the same state

        case (current_state)
            S_WALK_LEFT: begin
                if (!ground) begin
                    next_state = S_FALL;
                end else if (dig) begin
                    next_state = S_DIG;
                end else if (bump_left || bump_right) begin
                    next_state = S_WALK_RIGHT;
                end
            end
            S_WALK_RIGHT: begin
                if (!ground) begin
                    next_state = S_FALL;
                end else if (dig) begin
                    next_state = S_DIG;
                end else if (bump_left || bump_right) begin
                    next_state = S_WALK_LEFT;
                end
            end
            S_FALL: begin
                if (ground) begin
                  if (fall_count >= 20) begin
                    next_state = S_SPLAT;
                  end else begin
                    if (walk_left)
                      next_state = S_WALK_LEFT;
                    else
                      next_state = S_WALK_RIGHT;
                  end
                end
            end
            S_DIG: begin
                if (!ground) begin
                    next_state = S_FALL;
                end
            end
            S_SPLAT: begin
              next_state = S_SPLAT;
            end
            default: next_state = S_WALK_LEFT;
        endcase
    end

    // Fall counter logic
    always @(posedge clk) begin
        if (areset) begin
            fall_count <= 0;
        end else if (current_state == S_FALL) begin
            if (ground) begin
                fall_count <= 0;
            } else begin
                fall_count <= fall_count + 1;
            end
        end else begin
            fall_count <= 0;
        end
    end

    // State update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S_WALK_LEFT;
            fall_count <= 0;
        } else begin
            current_state <= next_state;
        end
    end

endmodule