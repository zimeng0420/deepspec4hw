module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    typedef enum reg [1:0] {
        STATE_A = 2'd0,
        STATE_B0 = 2'd1,
        STATE_B1 = 2'd2,
        STATE_B2 = 2'd3
    } state_t;

    state_t state, next_state;
    reg [1:0] count;

    always @(posedge clk) begin
        if (reset)
            state <= STATE_A;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        z = 0;

        case (state)
            STATE_A: begin
                if (s)
                    next_state = STATE_B0;
            end
            STATE_B0: begin
                count = 0;
                if (w)
                    count = count + 1;
                next_state = STATE_B1;
            end
            STATE_B1: begin
                if (w)
                    count = count + 1;
                next_state = STATE_B2;
            end
            STATE_B2: begin
                if (w)
                    count = count + 1;
                if (count == 2)
                    z = 1;
                next_state = STATE_B0;
            end
        endcase
    end

endmodule