module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    typedef enum logic {A, B} state_t;
    state_t current_state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= B;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        case (current_state)
            A: begin
                out = 0;
                if (in == 0) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                out = 1;
                if (in == 0) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
            end
            default: begin
                next_state = B; // default to state B
            end
        endcase
    end

endmodule