module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        S0 = 2'b00,  // Initial state, looking for 1 to initiate inversion
        S1 = 2'b01,  // State for complementing 0's
        S2 = 2'b10   // State for passing remaining bits unchanged
    } state_t;
    
    state_t state, next_state;

    // State transition logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        case (state)
            S0: next_state = x ? S1 : S0; // Begin inversion on finding first 1
            S1: next_state = S2;          // Once started, only one bit complement needed
            S2: next_state = S2;          // Pass through remaining bits
            default: next_state = S0;
        endcase
    end

    // Output logic
    always_comb begin
        case (state)
            S0: z = x;         // Output same as input
            S1: z = ~x;        // Complement the bit
            S2: z = x;         // Output remains the same as input
            default: z = 0;
        endcase
    end

endmodule