module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;
    
    state_t state, next_state;
    
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end
    
    always_comb begin
        case (state)
            A: begin
                out = 0;
                if (in)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                out = 0;
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
            C: begin
                out = 0;
                if (in)
                    next_state = D;
                else
                    next_state = A;
            end
            D: begin
                out = 1;
                if (in)
                    next_state = B;
                else
                    next_state = C;
            end
        endcase
    end

endmodule