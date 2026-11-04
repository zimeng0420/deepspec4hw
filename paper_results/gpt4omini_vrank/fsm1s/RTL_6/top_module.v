module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    typedef enum reg [1:0] {B, A} state_type;
    state_type state, next_state;

    always @(posedge clk or posedge reset) begin
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
                if (in == 0) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
            end
            A: begin
                out = 0;
                if (in == 0) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            default: begin
                next_state = B;
            end
        endcase
    end

endmodule