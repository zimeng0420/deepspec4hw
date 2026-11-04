module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    typedef enum reg [1:0] {
        STATE_INACTIVE = 2'b00,
        STATE_START = 2'b01,
        STATE_COMPLEMENT = 2'b10
    } state_t;
    
    state_t state, next_state;
    reg flip_bit;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_INACTIVE;
            z <= 1'b0;
            flip_bit <= 1'b1;
        end else begin
            state <= next_state;
            if (state == STATE_COMPLEMENT) begin
                z <= x ^ flip_bit;
                if (x == 1'b0 && flip_bit == 1'b1)
                    flip_bit <= 1'b0;
            end else begin
                z <= x;
            end
        end
    end

    always @(*) begin
        case (state)
            STATE_INACTIVE: next_state = STATE_START;
            STATE_START: next_state = STATE_COMPLEMENT;
            STATE_COMPLEMENT: next_state = STATE_COMPLEMENT;
            default: next_state = STATE_INACTIVE;
        endcase
    end

endmodule