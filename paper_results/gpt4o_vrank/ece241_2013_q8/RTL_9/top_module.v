module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        S1     = 2'b01,
        S10    = 2'b10
    } state_t;
    
    state_t state, next_state;
    
    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    always_comb begin
        next_state = state;
        z = 1'b0;
        case (state)
            IDLE: begin
                if (x)
                    next_state = S1;
            end
            S1: begin
                if (!x)
                    next_state = S10;
            end
            S10: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1;
                end else begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end
    
endmodule