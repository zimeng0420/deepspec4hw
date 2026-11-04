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

    always @(posedge clk) begin
        if (reset) begin
            current_state <= B;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        case (current_state)
            A: begin
                if (in) begin
                    next_state = A;
                    out = 0;
                end else begin
                    next_state = B;
                    out = 0;
                end
            end
            B: begin
                if (in) begin
                    next_state = B;
                    out = 1;
                end else begin
                    next_state = A;
                    out = 1;
                end
            end
            default: begin
                next_state = B;
                out = 1;
            end
        endcase
    end

endmodule