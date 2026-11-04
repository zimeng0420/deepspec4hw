module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    typedef enum reg [0:0] {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk) begin
        if (reset) 
            current_state <= B;
        else 
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            A: begin
                if (in)
                    next_state = A;
                else
                    next_state = B;
                out = 1'b0;
            end
            
            B: begin
                if (in)
                    next_state = B;
                else
                    next_state = A;
                out = 1'b1;
            end
            
            default: begin
                next_state = A;
                out = 1'b0;
            end
        endcase
    end

endmodule