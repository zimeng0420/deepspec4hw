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

    parameter IDLE = 2'b00;
    parameter WALK_LEFT = 2'b01;
    parameter WALK_RIGHT = 2'b10;
    parameter FALLING = 2'b11;
    parameter DIGGING = 2'b00; // Digging is also IDLE (no walk)

    reg [1:0] state;
    reg [1:0] next_state;
    reg dig_start;
    reg walk_dir; // 0: left, 1: right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            walk_dir <= 0; // Default to walk left after reset
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        dig_start = 1'b0;
        case (state)
            IDLE: begin
                if (ground) begin
                    if (walk_dir == 0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;

                end else begin
                    next_state = FALLING;
                end
            end
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_right) begin
                    walk_dir = 1;
                    next_state = WALK_RIGHT;
                end else if (dig && ground) begin
                    dig_start = 1'b1;
                    next_state = DIGGING;

                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                   next_state = FALLING;
                end else if (bump_left) begin
                    walk_dir = 0;
                    next_state = WALK_LEFT;
                end else if (dig && ground) begin
                    dig_start = 1'b1;
                   next_state = DIGGING;
                end
            end
            FALLING: begin
                if (ground) begin
                    if (walk_dir == 0)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end
            end

            DIGGING: begin
                if (!ground) begin
                   next_state = FALLING;
                end
            end
            default: next_state = IDLE;
        endcase
    end
    
    assign walk_left = (state == WALK_LEFT) || (state == DIGGING && walk_dir ==0);
    assign walk_right = (state == WALK_RIGHT) || (state == DIGGING && walk_dir == 1);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

endmodule