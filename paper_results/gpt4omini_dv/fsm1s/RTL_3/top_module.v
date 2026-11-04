module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    typedef enum logic [1:0] {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= B;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        case (current_state)
            A: begin
                next_state = (in) ? A : B;
                out = 1'b0;
            end
            B: begin
                next_state = (in) ? B : A;
                out = 1'b1;
            end
            default: begin
                next_state = B; // default to reset state
                out = 1'b1;     // default output
            end
        endcase
    end

endmodule