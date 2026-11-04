module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        S0,  // Initial state
        S1,  // State after reading '1'
        S2   // State after reading '10'
    } state_t;
    
    state_t current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            S0: next_state = x ? S1 : S0;          // Initial state to S1 on '1'
            S1: next_state = x ? S1 : S2;          // S1 to S2 on '0'
            S2: next_state = x ? S1 : S0;          // S2 to S0 on '0', S2 to S1 on '1'
            default: next_state = S0;
        endcase
    end

    // Output logic
    always @(*) begin
        z = (current_state == S2) && x;  // Assert z when in S2 and x is '1'
    end

    // State register with negative edge triggered async reset
    always @(negedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= S0;
        else
            current_state <= next_state;
    end

endmodule