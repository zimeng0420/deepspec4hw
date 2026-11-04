module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    typedef enum logic [1:0] {
        S0,  // No matching bits seen
        S1,  // Matching '1'
        S2   // Matching '10'
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
            z <= 0;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        z = 0;
        case (state)
            S0: begin
                if (x) next_state = S1;
            end
            S1: begin
                if (!x) next_state = S2;
                else next_state = S1;
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1;
                end else begin
                    next_state = S0;
                end
            end
        endcase
    end

endmodule