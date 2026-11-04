module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg splatter
);

    // State Definitions
    localparam IDLE = 0;        // Initial state
    localparam WALK_LEFT = 1;
    localparam WALK_RIGHT = 2;
    localparam FALL = 3;
    localparam DIG = 4;
    localparam SPLATTERED = 5;

    // State Register
    reg [2:0] state;
    reg [2:0] next_state;

    // Internal Signals
    reg falling;
    reg digging;
    reg [5:0] fall_counter;
    reg prev_ground;


    // State Transition Logic
    always @(*) begin
        next_state = state;
        walk_left = 0;
        walk_right = 0;
        aaah = 0;

        case (state)
            IDLE: begin
                walk_left = 1; // Default: start walking left
                next_state = WALK_LEFT;
            end

            WALK_LEFT: begin
                walk_left = 1;
                if (!ground) begin
                    next_state = FALL;
                end else if (bump_right) begin
                    next_state = WALK_RIGHT;
                end else if (dig) begin
                    next_state = DIG;
                end
            end

            WALK_RIGHT: begin
                walk_right = 1;
                if (!ground) begin
                    next_state = FALL;
                end else if (bump_left) begin
                    next_state = WALK_LEFT;
                end else if (dig) begin
                    next_state = DIG;
                end
            end

            FALL: begin
                aaah = 1;
                if (ground && fall_counter <= 20) begin
                   if (walk_left) next_state = WALK_LEFT;
                   else next_state = WALK_RIGHT;
                end else if (ground && fall_counter > 20) begin
                   next_state = SPLATTERED;
                end
            end

            DIG: begin
                if (!ground) begin
                   next_state = FALL;
                end
                else if (walk_left) walk_left =1;
                else if(walk_right) walk_right =1;
            end

            SPLATTERED: begin
                splatter = 1;
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
            end
        endcase
    end


    // Output Logic - Fall counter and Digging
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            fall_counter <= 0;
            splatter <= 0;
            falling <= 0;
            digging <= 0;
            prev_ground <= 1;
        end else begin
            state <= next_state;

            if (state == FALL) begin
                fall_counter <= fall_counter + 1;
                falling <= 1;
            end else if (state != FALL) begin
                fall_counter <= 0;
                falling <= 0;
            end
            if (state == SPLATTERED) begin
              splatter <= 1;
            end

        end
    end
endmodule