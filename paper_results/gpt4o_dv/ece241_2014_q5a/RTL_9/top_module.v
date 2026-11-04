module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        PROPAGATE = 2'b01,
        INVERT = 2'b10
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) 
            state <= IDLE;
        else 
            state <= next_state;
    end

    always_comb begin
        case (state)
            IDLE: 
                next_state = (x == 1) ? INVERT : PROPAGATE;
            PROPAGATE: 
                next_state = (x == 1) ? INVERT : PROPAGATE;
            INVERT: 
                next_state = INVERT;
            default: 
                next_state = IDLE;
        endcase
    end

    assign z = (state == INVERT) ? ~x : x;

endmodule