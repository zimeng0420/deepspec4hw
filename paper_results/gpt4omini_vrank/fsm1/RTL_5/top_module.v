module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);
    
    typedef enum reg [1:0] {A, B} state_t; 
    state_t state, next_state;

    // Asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B; // Reset to state B
        else
            state <= next_state;
    end
    
    // Output logic
    always @(state) begin
        case (state)
            A: out = 0;
            B: out = 1;
        endcase
    end
    
    // State transition logic
    always @(*) begin
        case (state)
            A: 
                if (in == 0)
                    next_state = B; 
                else
                    next_state = A;
            B: 
                if (in == 0)
                    next_state = A; 
                else
                    next_state = B;
        endcase
    end
    
endmodule