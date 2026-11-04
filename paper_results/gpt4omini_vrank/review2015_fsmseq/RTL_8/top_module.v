module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting);

    typedef enum reg [2:0] {
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100
    } state_t;
    
    state_t current_state, next_state;
    
    always @(posedge clk) begin
        if (reset) 
            current_state <= S0;
        else 
            current_state <= next_state;
    end
    
    always @(*) begin
        case (current_state)
            S0: if (data) next_state = S1; else next_state = S0;
            S1: if (data) next_state = S2; else next_state = S0;
            S2: if (!data) next_state = S3; else next_state = S0;
            S3: if (data) next_state = S4; else next_state = S0;
            S4: next_state = S4; // stay in S4 once the sequence is found
            default: next_state = S0;
        endcase
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) 
            start_shifting <= 0;
        else if (current_state == S4)
            start_shifting <= 1;
    end

endmodule