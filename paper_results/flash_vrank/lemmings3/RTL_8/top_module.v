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
    localparam DIG  = 2'b10;

    // State register
    reg [1:0] state;
    reg [1:0] next_state;

    // Direction register
    reg walk_dir; // 1 for right, 0 for left
    reg next_walk_dir;

    // Output registers
    reg aaah_r;
    reg digging_r;

    // Next state logic
    always @(*) begin
        next_state = state;
        next_walk_dir = walk_dir;
        aaah_r = 0;
        digging_r = 0;

        case (state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                    aaah_r = 1;
                end else if (dig) begin
                    next_state = DIG;
                    digging_r = 1;
                end else if (bump_left) begin
                    next_walk_dir = 1;
                end else if (bump_right) begin
                    next_walk_dir = 0;
                end else begin
                    next_walk_dir = walk_dir;
                end
            end
            FALL: begin
                aaah_r = 1;
                if (ground) begin
                    next_state = WALK;
                end else begin
                    next_walk_dir = walk_dir;
                end
            end
            DIG: begin
                digging_r = 1;
                if (!ground) begin
                    next_state = FALL;
                    aaah_r = 1;
                end else begin
                    next_walk_dir = walk_dir;
                end

            end
            default: begin
                next_state = WALK;
                next_walk_dir = 0;
            end
        endcase
    end

    // State update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK;
            walk_dir <= 0;
        end else begin
            state <= next_state;
            walk_dir <= next_walk_dir;
        end
    end

    // Output logic
    assign walk_left = (state == WALK) && (walk_dir == 0);
    assign walk_right = (state == WALK) && (walk_dir == 1);
    assign aaah = aaah_r;
    assign digging = digging_r;

endmodule