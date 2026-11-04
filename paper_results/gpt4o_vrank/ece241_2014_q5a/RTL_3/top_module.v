module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    typedef enum reg [1:0] {
        STATE_INIT = 2'b00,
        STATE_PASS = 2'b01,
        STATE_FLIP = 2'b10
    } state_t;

    reg state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            STATE_INIT: next_state = (x == 1'b1) ? STATE_FLIP : STATE_PASS;
            STATE_PASS: next_state = state;
            STATE_FLIP: next_state = state;
            default: next_state = STATE_INIT;
        endcase
    end

    // State update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_INIT;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    always @(*) begin
        case (state)
            STATE_INIT: z = x;
            STATE_PASS: z = x;
            STATE_FLIP: z = ~x;
            default: z = 1'b0;
        endcase
    end

endmodule