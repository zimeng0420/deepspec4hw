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

    reg [2:0] state, next_state;
    
    // State encoding
    localparam LEFT_WALK = 3'b000;
    localparam RIGHT_WALK = 3'b001;
    localparam LEFT_FALL = 3'b010;
    localparam RIGHT_FALL = 3'b011;
    localparam LEFT_DIG = 3'b100;
    localparam RIGHT_DIG = 3'b101;
    
    // State transition logic
    always @(*) begin
        case (state)
            LEFT_WALK: begin
                if (!ground)
                    next_state = LEFT_FALL;
                else if (dig)
                    next_state = LEFT_DIG;
                else if (bump_left)
                    next_state = RIGHT_WALK;
                else
                    next_state = LEFT_WALK;
            end
            RIGHT_WALK: begin
                if (!ground)
                    next_state = RIGHT_FALL;
                else if (dig)
                    next_state = RIGHT_DIG;
                else if (bump_right)
                    next_state = LEFT_WALK;
                else
                    next_state = RIGHT_WALK;
            end
            LEFT_FALL: begin
                if (ground)
                    next_state = LEFT_WALK;
                else
                    next_state = LEFT_FALL;
            end
            RIGHT_FALL: begin
                if (ground)
                    next_state = RIGHT_WALK;
                else
                    next_state = RIGHT_FALL;
            end
            LEFT_DIG: begin
                if (!ground)
                    next_state = LEFT_FALL;
                else
                    next_state = LEFT_DIG;
            end
            RIGHT_DIG: begin
                if (!ground)
                    next_state = RIGHT_FALL;
                else
                    next_state = RIGHT_DIG;
            end
            default: begin
                next_state = LEFT_WALK;
            end
        endcase
    end

    // State flip-flops with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT_WALK;
        else
            state <= next_state;
    end

    // Output logic
    assign walk_left = (state == LEFT_WALK);
    assign walk_right = (state == RIGHT_WALK);
    assign aaah = (state == LEFT_FALL) || (state == RIGHT_FALL);
    assign digging = (state == LEFT_DIG) || (state == RIGHT_DIG);

endmodule