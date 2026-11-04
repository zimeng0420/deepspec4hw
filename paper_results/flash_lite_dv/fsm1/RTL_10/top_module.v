module top_module(
    input clk,
    input in,
    input areset,
    output out
);

    parameter A = 0;
    parameter B = 1;

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            case (state)
                A: state <= in ? A : B;
                B: state <= in ? B : A;
            endcase
        end
    end

    assign out = state;

endmodule