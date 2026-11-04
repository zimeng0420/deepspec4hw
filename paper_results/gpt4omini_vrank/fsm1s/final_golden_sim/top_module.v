module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);
    typedef enum reg [1:0] {B, A} state_t;
    state_t state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

    always @(state or in) begin
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
        endcase
    end
endmodule