module top_module (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

    typedef enum logic [2:0] {
        State_WalkLeft,
        State_WalkRight,
        State_FallLeft,
        State_FallRight,
        State_DigLeft,
        State_DigRight,
        State_Splatter
    } state_t;

    state_t state, next_state;
    logic [4:0] fall_count;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= State_WalkLeft;
            fall_count <= 0;
        end
        else begin
            state <= next_state;
            if (aaah)
                fall_count <= fall_count + 1;
            else
                fall_count <= 0;
        end
    end

    always_comb begin
        case (state)
            State_WalkLeft: begin
                if (!ground) next_state = State_FallLeft;
                else if (dig) next_state = State_DigLeft;
                else if (bump_left || (bump_left && bump_right)) next_state = State_WalkRight;
                else next_state = State_WalkLeft;
            end
            State_WalkRight: begin
                if (!ground) next_state = State_FallRight;
                else if (dig) next_state = State_DigRight;
                else if (bump_right || (bump_left && bump_right)) next_state = State_WalkLeft;
                else next_state = State_WalkRight;
            end
            State_FallLeft: begin
                if (ground) begin
                    if (fall_count > 20) next_state = State_Splatter;
                    else next_state = State_WalkLeft;
                end
                else next_state = State_FallLeft;
            end
            State_FallRight: begin
                if (ground) begin
                    if (fall_count > 20) next_state = State_Splatter;
                    else next_state = State_WalkRight;
                end
                else next_state = State_FallRight;
            end
            State_DigLeft: begin
                if (!ground) next_state = State_FallLeft;
                else next_state = State_DigLeft;
            end
            State_DigRight: begin
                if (!ground) next_state = State_FallRight;
                else next_state = State_DigRight;
            end
            State_Splatter: begin
                next_state = State_Splatter;
            end
        endcase
    end

    always_comb begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;
        case (state)
            State_WalkLeft: walk_left = 1;
            State_WalkRight: walk_right = 1;
            State_FallLeft, State_FallRight: aaah = 1;
            State_DigLeft: begin
                walk_left = 1;
                digging = 1;
            end
            State_DigRight: begin
                walk_right = 1;
                digging = 1;
            end
            State_Splatter: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end

endmodule