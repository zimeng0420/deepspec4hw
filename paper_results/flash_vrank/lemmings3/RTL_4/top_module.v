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
    reg [1:0] current_state, next_state;

    // Direction register
    reg walk_dir, next_walk_dir; // 1: left, 0: right

    // Output registers
    reg aaah_r, digging_r;

    // State transition logic
    always @(*) begin
        next_state = current_state;
        next_walk_dir = walk_dir;
        aaah_r = 0;
        digging_r = 0;

        case (current_state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                    aaah_r = 1;
                end else if (dig) begin
                    next_state = DIG;
                    digging_r = 1;
                end else if (bump_left) begin
                    next_walk_dir = 0; // Walk right
                end else if (bump_right) begin
                    next_walk_dir = 1; // Walk left
                end
            end
            FALL: begin
                aaah_r = 1;
                if (ground) begin
                    next_state = WALK;
                end
            end
            DIG: begin
                digging_r = 1;
                if (!ground) begin
                    next_state = FALL;
                    aaah_r = 1;
                end
            end
            default: begin
               next_state = WALK;
               next_walk_dir = 1;
            end
        endcase
    end

    // State update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK;
            walk_dir <= 1; // Start walking left
        end else begin
            current_state <= next_state;
            walk_dir <= next_walk_dir;
        end
    end

    // Output logic
    assign walk_left = (current_state == WALK) && walk_dir;
    assign walk_right = (current_state == WALK) && !walk_dir;
    assign aaah = aaah_r;
    assign digging = digging_r;

endmodule