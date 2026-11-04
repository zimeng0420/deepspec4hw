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
    localparam WALK = 2'b00;
    localparam FALL = 2'b01;
    localparam DIG = 2'b10;

    reg [1:0] current_state, next_state;
    reg walking_left, next_walking_left;

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK;
            walking_left <= 1;
        end else begin
            current_state <= next_state;
            walking_left <= next_walking_left;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        next_walking_left = walking_left;

        case (current_state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if (bump_left) begin
                    next_walking_left = 0;
                end else if (bump_right) begin
                    next_walking_left = 1;
                end
            end
            FALL: begin
                if (ground) begin
                    next_state = WALK;
                end
            end
            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                end
            end
            default: begin
                next_state = WALK;
                next_walking_left = 1;
            end
        endcase
    end

    // Output logic
    assign walk_left = (current_state == WALK) && walking_left;
    assign walk_right = (current_state == WALK) && !walking_left;
    assign aaah = (current_state == FALL);
    assign digging = (current_state == DIG);

endmodule