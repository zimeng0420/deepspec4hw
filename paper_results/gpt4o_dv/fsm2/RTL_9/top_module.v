module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output out
);

    typedef enum logic [0:0] {
        STATE_OFF = 1'b0,
        STATE_ON = 1'b1
    } state_t;

    state_t state, next_state;

    // Sequential state register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= STATE_OFF;
        else
            state <= next_state;
    end

    // Combinational logic for next state
    always @(*) begin
        case (state)
            STATE_OFF: begin
                if (j)
                    next_state = STATE_ON;
                else
                    next_state = STATE_OFF;
            end
            STATE_ON: begin
                if (k)
                    next_state = STATE_OFF;
                else
                    next_state = STATE_ON;
            end
        endcase
    end

    // Output logic
    assign out = (state == STATE_ON);

endmodule