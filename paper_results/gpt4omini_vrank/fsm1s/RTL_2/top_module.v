module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);
    typedef enum reg [1:0] {B, A} state_t;
    state_t current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= B;
        end else begin
            current_state <= next_state;
        end
    end

    always @(current_state or in) begin
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
            default: begin
                next_state = B; // default state
                out = 1; // default output
            end
        endcase
    end
endmodule