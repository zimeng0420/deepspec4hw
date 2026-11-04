module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    typedef enum reg [1:0] {
        STATE_A = 2'b01,
        STATE_B = 2'b10
    } state_t;
    
    state_t state, next_state;

    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= STATE_A;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            STATE_A: begin
                if (x == 1'b0) begin
                    next_state = STATE_A;
                    z = 1'b0;
                end else begin
                    next_state = STATE_B;
                    z = 1'b1;
                end
            end
            STATE_B: begin
                if (x == 1'b0) begin
                    next_state = STATE_B;
                    z = 1'b1;
                end else begin
                    next_state = STATE_B;
                    z = 1'b0;
                end
            end
            default: begin
                next_state = STATE_A;
                z = 1'b0;
            end
        endcase
    end

endmodule