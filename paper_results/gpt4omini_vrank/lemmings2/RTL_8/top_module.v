module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    typedef enum reg [1:0] {
        LEFT,
        RIGHT,
        FALLING
    } state_t;

    state_t current_state, next_state;

    always_ff @ (posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= LEFT;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @ (current_state or bump_left or bump_right or ground) begin
        case (current_state)
            LEFT: begin
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
                if (bump_left) begin
                    next_state = RIGHT;
                end else if (bump_right) begin
                    next_state = LEFT;
                end else if (!ground) begin
                    next_state = FALLING;
                end else begin
                    next_state = LEFT;
                end
            end
            
            RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
                if (bump_left) begin
                    next_state = RIGHT;
                end else if (bump_right) begin
                    next_state = LEFT;
                end else if (!ground) begin
                    next_state = FALLING;
                end else begin
                    next_state = RIGHT;
                end
            end

            FALLING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                if (ground) begin
                    if (bump_left || bump_right) begin
                        next_state = current_state; // maintain direction
                    end else begin
                        next_state = current_state; // maintain direction
                    end
                end else begin
                    next_state = FALLING;
                end
            end
        
            default: next_state = LEFT;
        endcase
    end
endmodule