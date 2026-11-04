module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    typedef enum reg [1:0] {
        S_IDLE = 2'b00,
        S_FLIP = 2'b01,
        S_PASS = 2'b10
    } state_t;

    state_t state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) 
            state <= S_IDLE;
        else 
            state <= next_state;
    end

    always @(*) begin
        case(state)
            S_IDLE: begin
                if (x == 1'b1)
                    next_state = S_FLIP;
                else
                    next_state = S_PASS;
            end
            S_FLIP: begin
                next_state = S_FLIP;
            end
            S_PASS: begin
                next_state = S_PASS;
            end
            default: next_state = S_IDLE;
        endcase
    end

    always @(*) begin
        case(state)
            S_FLIP: z = ~x;
            S_PASS: z = x;
            S_IDLE: z = x;
            default: z = x;
        endcase
    end

endmodule