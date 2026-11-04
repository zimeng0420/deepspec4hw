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

    typedef enum reg [2:0] {
        WL = 3'b000,  // Walking Left
        WR = 3'b001,  // Walking Right
        FL = 3'b010,  // Falling Left
        FR = 3'b011,  // Falling Right
        DL = 3'b100,  // Digging Left
        DR = 3'b101   // Digging Right
    } state_t;

    state_t state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            WL: begin
                if (!ground)
                    next_state = FL;
                else if (dig)
                    next_state = DL;
                else if (bump_left || bump_right)
                    next_state = WR;
                else
                    next_state = WL;
            end

            WR: begin
                if (!ground)
                    next_state = FR;
                else if (dig)
                    next_state = DR;
                else if (bump_right || bump_left)
                    next_state = WL;
                else
                    next_state = WR;
            end
            
            FL: begin
                if (ground)
                    next_state = WL;
                else
                    next_state = FL;
            end

            FR: begin
                if (ground)
                    next_state = WR;
                else
                    next_state = FR;
            end

            DL: begin
                if (!ground)
                    next_state = FL;
                else
                    next_state = DL;
            end

            DR: begin
                if (!ground)
                    next_state = FR;
                else
                    next_state = DR;
            end

            default: next_state = WL;
        endcase
    end

    always @(*) begin
        walk_left = (state == WL);
        walk_right = (state == WR);
        aaah = (state == FL) || (state == FR);
        digging = (state == DL) || (state == DR);
    end

endmodule