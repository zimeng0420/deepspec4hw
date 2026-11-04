module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    typedef enum reg [1:0] {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= B;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            B: begin
                out = 1;
                if (in == 0)
                    next_state = A;
                else
                    next_state = B;
            end
            A: begin
                out = 0;
                if (in == 0)
                    next_state = B;
                else
                    next_state = A;
            end
        endcase
    end

endmodule