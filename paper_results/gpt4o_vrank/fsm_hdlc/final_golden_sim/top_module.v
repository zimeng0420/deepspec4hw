module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    typedef enum reg [2:0] {
        STATE_0 = 3'b000,
        STATE_1 = 3'b001,
        STATE_11 = 3'b010,
        STATE_111 = 3'b011,
        STATE_1111 = 3'b100,
        STATE_11111 = 3'b101,
        STATE_111111 = 3'b110,
        STATE_1111111 = 3'b111
    } state_type;

    state_type state, next_state;

    always @(posedge clk) begin
        if (reset)
            state <= STATE_0;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        disc = 0;
        flag = 0;
        err = 0;

        case (state)
            STATE_0: begin
                if (in)
                    next_state = STATE_1;
            end
            STATE_1: begin
                if (in)
                    next_state = STATE_11;
                else
                    next_state = STATE_0;
            end
            STATE_11: begin
                if (in)
                    next_state = STATE_111;
                else
                    next_state = STATE_0;
            end
            STATE_111: begin
                if (in)
                    next_state = STATE_1111;
                else
                    next_state = STATE_0;
            end
            STATE_1111: begin
                if (in)
                    next_state = STATE_11111;
                else
                    next_state = STATE_0;
            end
            STATE_11111: begin
                if (in)
                    next_state = STATE_111111;
                else
                    next_state = STATE_0;
            end
            STATE_111111: begin
                if (in)
                    next_state = STATE_1111111;
                else begin
                    next_state = STATE_0;
                    flag = 1;
                end
            end
            STATE_1111111: begin
                if (in)
                    err = 1;
                else begin
                    next_state = STATE_0;
                    disc = 1;
                end
            end
        endcase
    end
endmodule