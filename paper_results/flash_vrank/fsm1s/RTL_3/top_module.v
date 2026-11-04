module top_module (
    input clk,
    input in,
    input reset,
    output out
);

    reg state;
    reg next_state;

    parameter A = 1'b0;
    parameter B = 1'b1;

    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            A: begin
                if (in == 0) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                if (in == 0) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
            end
            default: next_state = B;
        endcase
    end

    assign out = state;

endmodule