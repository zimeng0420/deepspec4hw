module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    typedef enum logic [1:0] {
        STATE_A = 1'b0,
        STATE_B = 1'b1
    } state_t;
    
    state_t current_state, next_state;
    
    // State transition logic
    always @(*) begin
        case(current_state)
            STATE_B: next_state = (in == 1'b0) ? STATE_A : STATE_B;
            STATE_A: next_state = (in == 1'b0) ? STATE_B : STATE_A;
        endcase
    end
    
    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= STATE_B;
        else
            current_state <= next_state;
    end
    
    // Output logic
    always @(*) begin
        case(current_state)
            STATE_B: out = 1'b1;
            STATE_A: out = 1'b0;
        endcase
    end

endmodule