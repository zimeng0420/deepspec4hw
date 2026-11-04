module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);
    typedef enum logic [1:0] {
        S0, // Waiting for first '1'
        S1  // Inverting bits
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) 
            state <= S0;
        else 
            state <= next_state;
    end

    always_ff @(state, x) begin
        case (state)
            S0: begin
                if (x) 
                    next_state = S1;
                else 
                    next_state = S0;
                z = 1'b1; // Output for first '0' in S0
            end
            S1: begin
                next_state = S1; // Stay in S1
                z = ~x; // Output inverted x in S1
            end
        endcase
    end

endmodule