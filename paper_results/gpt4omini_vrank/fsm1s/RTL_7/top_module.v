module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    reg state, next_state;

    parameter B = 1'b0, A = 1'b1;

    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            B: begin
                out = 1;
                if (in) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            A: begin
                out = 0;
                if (in) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
            end
            default: begin
                next_state = B; // Reset to state B
                out = 1; // Default output state
            end
        endcase
    end

endmodule