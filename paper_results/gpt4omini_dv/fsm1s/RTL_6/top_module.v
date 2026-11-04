module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    typedef enum logic [0:0] {A = 1'b0, B = 1'b1} state_t;
    state_t current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset) 
            current_state <= B;
        else 
            current_state <= next_state;
    end

    always_comb begin
        case (current_state)
            A: begin
                next_state = (in) ? A : B;
                out = 0;
            end
            B: begin
                next_state = (in) ? B : A;
                out = 1;
            end
            default: begin
                next_state = B;
                out = 1;
            end
        endcase
    end

endmodule