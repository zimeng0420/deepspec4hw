module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    typedef enum logic [1:0] {
        STATE_ZERO = 2'b00,
        STATE_ONE = 2'b01,
        STATE_TWOS = 2'b10
    } state_t;
    
    state_t state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) 
            state <= STATE_ZERO;
        else 
            state <= next_state;
    end

    always_comb begin
        case (state)
            STATE_ZERO: begin
                if (x == 1'b1) 
                    next_state = STATE_ONE;
                else 
                    next_state = STATE_ZERO;
                z = x;
            end
            
            STATE_ONE: begin
                if (x == 1'b1)
                    next_state = STATE_ONE;
                else 
                    next_state = STATE_TWOS;
                z = ~x;
            end
            
            STATE_TWOS: begin
                next_state = STATE_TWOS;
                z = ~x;
            end

            default: begin
                next_state = STATE_ZERO;
                z = 1'b0;
            end
        endcase
    end

endmodule