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

    reg [1:0] current_state, next_state;
    reg walking_left; // Store walking direction before falling/digging
    reg digging_internal;

    // State register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK;
            walking_left <= 1;
            digging_internal <= 0;
        end else begin
            current_state <= next_state;
            digging_internal <= (current_state == DIG) ? 1 : 0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                    walking_left = walking_left;  // keep direction
                end else if (dig) begin
                    next_state = DIG;
                    walking_left = walking_left; // keep direction
                end else if (bump_left) begin
                    next_state = WALK;
                    walking_left = 0;
                end else if (bump_right) begin
                    next_state = WALK;
                    walking_left = 1;
                end else begin
                    next_state = WALK;
                end
            end
            FALL: begin
                if (ground) begin
                    next_state = WALK;
                end else begin
                    next_state = FALL;
                end
            end
            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                    walking_left = walking_left;  // keep direction
                end else begin
                    next_state = DIG;
                end
            end
            default: next_state = WALK;
        end
    end

    // Output logic
    assign walk_left  = (current_state == WALK) ? walking_left : 0;
    assign walk_right = (current_state == WALK) ? ~walking_left : 0;
    assign aaah       = (current_state == FALL) ? 1 : 0;
    assign digging    = digging_internal;


endmodule