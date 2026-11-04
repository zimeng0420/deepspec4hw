module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    typedef enum logic {B, A} state_t;
    state_t current_state, next_state;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= B; // Reset state is B
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        case (current_state)
            A: begin
                if (in) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
                out = 0; // Output is 0 in state A
            end
            B: begin
                if (in) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
                out = 1; // Output is 1 in state B
            end
        endcase
    end

endmodule