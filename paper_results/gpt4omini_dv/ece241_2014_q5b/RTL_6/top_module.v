module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state_A, state_B;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            state_A <= (state_A && ~x) || (state_B && x);
            state_B <= (state_B && (x == 1)) || (state_A && (x == 0));
        end
    end

    always @(*) begin
        z = (state_A && ~x) || (state_B && x);
    end

endmodule