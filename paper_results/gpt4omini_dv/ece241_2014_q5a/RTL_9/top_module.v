module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);
    reg [1:0] state, next_state;
    
    localparam S0 = 2'b00; // Waiting for the first '1'
    localparam S1 = 2'b01; // Inverting bits

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) 
            state <= S0;
        else 
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: begin
                if (x) 
                    next_state = S1; // Move to state S1 on first '1'
                else 
                    next_state = S0; // Stay in state S0
            end
            S1: begin
                next_state = S1; // Stay in state S1
            end
            default: 
                next_state = S0; // Default state
        endcase
    end
    
    // Output logic
    always @(*) begin
        case (state)
            S0: 
                z = 1'b1; // Output 1 when in S0
            S1: 
                z = ~x;   // Output inverted x when in S1
            default: 
                z = 1'b0; // Default output
        endcase
    end
endmodule