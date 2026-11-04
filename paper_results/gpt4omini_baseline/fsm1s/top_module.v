module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);
    typedef enum reg [1:0] {B, A} state_t;
    state_t current_state, next_state;

    always @(posedge clk) begin
        if (reset) 
            current_state <= B;
        else 
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            B: begin
                out = 1;
                if (in) 
                    next_state = B;
                else 
                    next_state = A;
            end
            A: begin
                out = 0;
                if (in) 
                    next_state = A;
                else 
                    next_state = B;
            end
        endcase
    end
endmodule